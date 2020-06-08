---
title: Tutorial laravel project with docker
---

# Create new laravel project with docker

1.  At the terminal, clone the laravel:
````bash
$ git clone git@github.com:laravel/laravel.git app_name
````
2.  Access the folder:
````bash
$ cd app_name
````
3.  Remove .git/ :
````bash
$ rm -rf .git/
````
4. Create the php folder in the project, and add the php configuration file:
````bash
$ mkdir -p php
````
````bash
$ nano php/local.ini
````
* **Content:**
````
        upload_max_filesize=40M
        post_max_size=40M
        memory_limit=4G
````
5. Create the mysql folder in the project, and add the mysql configuration file:
````bash
$ mkdir -p mysql
````
````bash
$ nano mysql/my.cnf
````
* **Content:**
````
       [mysqld]
       	general_log = 1
       	general_log_file = /var/lib/mysql/general.log
````
6. Create the nginx/conf.d folder in the project, and add the configuration file:
````bash
$ mkdir -p nginx/conf.d
````
````bash
$ nano nginx/conf.d/app.conf
````
* **Content:**
````
       server {
           listen 80;
       
           index index.php index.html;
       
           error_log  /var/log/nginx/error.log;
           access_log /var/log/nginx/access.log;
           root /var/www/public;
       
           location ~ \.php$ {
               try_files $uri =404;
               fastcgi_split_path_info ^(.+\.php)(/.+)$;
               fastcgi_pass app:9000;
               fastcgi_index index.php;
               include fastcgi_params;
               fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
               fastcgi_param PATH_INFO $fastcgi_path_info;
           }
       
           location / {
               try_files $uri $uri/ /index.php?$query_string;
               gzip_static on;
           }
       
           client_max_body_size 5M;
           client_body_buffer_size 16k;
       }
````
7. At the root of the project create a Dockerfile file:
````bash
$ nano Dockerfile
````
* **Content:**

````
FROM php:7.4-fpm

ARG USER_ID=1000
ARG GROUP_ID=1000

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    --no-install-recommends apt-utils \
    libzip-dev \
    libonig-dev \
    default-mysql-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    sudo \
    ssh \
    procps \
    rsync

RUN pecl install xdebug

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-enable xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# NODEJS NVM ---------------------------------------------------------------------------------------------------------------
ARG NODE_VERSION=12.16.3
ARG NVM_DIR=/usr/local/nvm

# https://github.com/creationix/nvm#install-script
RUN mkdir $NVM_DIR && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# update npm
RUN npm install -g npm

# confirm installation
RUN node -v
RUN npm -v
# end NODEJS -----------------------------------------------------------------------------------------------------------


# YARN -----------------------------------------------------------------------------------------------------------------
RUN npm install -g yarn@berry
# end YARN -------------------------------------------------------------------------------------------------------------


# Define environment variables
ENV _USER www
ENV HOME /home/${_USER}/
ENV APP /var/www/
ENV VENDOR_PATH /vendor

# ADD an user called www
# --gecos GECOS
#          Set  the  gecos (information about the user) field for the new entry generated.  adduser will
#          not ask for finger information if this option is given
#
# The users of the group staff can install executables in /usr/local/bin and /usr/local/sbin without root privileges
RUN addgroup --gid $GROUP_ID ${_USER}
RUN adduser  --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID ${_USER} \
  && usermod -a -G sudo ${_USER} \
  && usermod -a -G staff ${_USER} \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo "${_USER}:${_USER}" | chpasswd


# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT commands.
RUN mkdir -p $HOME \
  && mkdir -p $APP \
  && mkdir -p $VENDOR_PATH \
  && chown -R ${_USER}:${_USER} $HOME \
  && chown -R ${_USER}:${_USER} $VENDOR_PATH \
  && chown -R ${_USER}:${_USER} $APP

# Copy existing application directory contents
COPY . $APP

# Cache vendor directo
RUN ln -sf /vendor /var/www/vendor

# Change current user to www
USER ${_USER}:${_USER}

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["php-fpm"]
````

{:start="8"}
8. At the root of the project, create a docker-compose.yml file:
````bash
$ nano docker-compose.yml
````
* **Content:**

````yml
version: '3.7'
services:

  #PHP Service
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: digitalocean.com/php
    container_name: app
    restart: unless-stopped
    tty: true
    environment:
      SERVICE_NAME: app
      SERVICE_TAGS: dev
    working_dir: /var/www
    volumes:
      - ./:/var/www
      - ./php/local.ini:/usr/local/etc/php/conf.d/local.ini
      - vendor_path:/vendor
    networks:
      - app-network

  #Nginx Service
  webserver:
    image: nginx:alpine
    container_name: webserver
    restart: unless-stopped
    tty: true
    ports:
      - "81:80"
      - "443:443"
    volumes:
      - ./:/var/www
      - ./nginx/conf.d/:/etc/nginx/conf.d/
      - vendor_path:/vendor
    networks:
      - app-network

  #MySQL Service
  db:
    image: mysql:5.7.22
    container_name: db
    restart: unless-stopped
    tty: true
    ports:
      - "3307:3306"
    environment:
      MYSQL_DATABASE: app_name
      MYSQL_USER: mysql_user
      MYSQL_PASSWORD: mysql_pwd
      MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
      SERVICE_TAGS: dev
      SERVICE_NAME: mysql
    volumes:
      - dbdata:/var/lib/mysql/
      - ./mysql/my.cnf:/etc/mysql/my.cnf
    networks:
      - app-network

#Docker Networks
networks:
  app-network:
    driver: bridge
#Volumes
volumes:
  dbdata:
    driver: local
  vendor_path:
````

{:start="9"}
9. To build the application image:
````bash
$ docker build .
````
10. Create the .env file at the root of the project:
````bash
$ mv .env.example .env
````
* **OBS:** Must have the same bank username and password as docker-compose.yml
11. Start the containers:
````bash
$docker-compose up -d
````
12. Install all packages with composer install:
````bash
$ docker-compose exec app composer install
````
13. Generate an application key:
````bash
$ docker-compose exec app php artisan key:generate
````
14. Access the project in the browser:
`http://localhost:8000`
* **Must have the same port as docker-compose.yml**