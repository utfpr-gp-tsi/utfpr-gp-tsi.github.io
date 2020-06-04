---
title: Deploy a laravel 7.x application
---

# Deploy a laravel 7.x application using deployer and docker


##### OBS

**(s) Servidor**

**(l) Local**

1. Connect to the server:
```bash
(l) $ ssh root@SERVER_IP
```
2. The root user must not be used on the server, so it is necessary to create a new user:
```bash
(s) $ sudo adduser deployer
```
3. After the new user is created, he must be added to sudoers in order for him to have sudo privileges:
```bash
(s) $ sudo usermod -aG sudo deployer
```
4. Set up an ssh key so that the user can access the server without having to enter the password:
* To create the RSA key pair, he first asks where he wants to save the key (.ssh / id_rsa) and immediately asks to enter the password twice to open the key:
```bash
(l) $ ssh-keygen -t rsa
```
* Send the created key to the server:
````bash
(l) $ ssh-copy-id -i ~/.ssh/id_rsa.pub deployer@SERVER-IP
````
* Finally, to test that everything is correct:
````bash
(l) $ ssh deployer@SERVER-IP
````
5. Install Docker and docker-compose on the server:
* Docker:
````bash
(s)  $ curl -fsSL https://get.docker.com -o get-docker.sh
````
````bash
(s)  $ sudo sh get-docker.sh
````
````bash
(s)  $ sudo usermod -aG docker deployer
````
* docker-compose:
````bash
(s)  $ sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
````
````bash
(s)  $ sudo chmod +x /usr/local/bin/docker-compose
````
6. Install nginx on the server, a container for nginx will not be used; therefore, there is no need to create and configure a new nginx to define which application should be redirected:
````bash
(s) $ sudo apt-get update
````
````bash
(s) $ sudo apt-get install nginx -y
````
7. It is necessary to add the user created to the www-data group to allow read and write access to /var/www:
* Add user to www-data:
````bash
(s) $ sudo adduser $USER www-data
````
* Change the owner of the files, allowing user access:
````bash
(s) $ sudo chown $USER:www-data -R /www
````
* Change file permissions by providing read, write and execute permissions:
````bash
(s) $ sudo chmod u=rwX,g=srX,o=rX -R /var/www
````
8. Allow the user to run nginx with sudo and without a password:
````bash
(s) $ sudo visudo
````
* Add these lines to the open file:
````
      # Commands to run as sudo without password
      deployer ALL=(ALL) NOPASSWD:/usr/sbin/nginx
````

9. Create a branch for production:
* Go to branch master:
  ````bash 
  (l) $ git ckeckout master
   ````
* Create a new branch:
  ````bash
  (l) $ git ckeckout -b production 
  ````

10. Install Deployer, the implementer must be installed inside the application container:
````bash
(l) $ docker-compose exec app composer require deployer/dist –dev
````
11. After installing Deployer, generate the configuration file for the deployment:
````bash
(l) $ docker-compose exec app vendor/bin/dep init -t Laravel
````
12. In an editor, open the deploy.php file, to configure it:
* Example of [deploy.php](example-file-deploy)

13. Allow access to the server via ssh through the container:
* Create a folder named .ssh within the project and copy your private key:
````bash
(l)$ cp ~/.ssh/id_rsa .ssh/
````
* Ignore the .ssh folder in the project:
````bash
(l)$ git update-index --assume-unchanged .ssh/
````
* Added the .ssh folder in gitignore

14. Allow the server to clone the project that is on github.com:
````bash
(s)$ ssh-keygen -t rsa
````
* Copy the key and on github.com, in settings, Deploy keys and then add deploy key add the public key:
```` bash
(s)$ cat ~/.ssh/id_rsa.pub
````
* Test access to github
````bash
(s)$ ssh -T git@github.com
```` 
15. In the project folder, create the folders for the deployment:
* In this folder, you will find the Dockerfile and docker-compose files
````bash
(l)$ mkdir -p deploy/production
(l)$ cd deploy/production
````
* Dockerfile:
````bash
(l)$ wget https://gist.githubusercontent.com/dmarczal/a0800aae0111f152fd69024f2ab13d77/raw/6f3ab5ae3ae01729b30de029101686583212f67b/Dockerfile
````
* Open the Dockerfile file, and just under procps \ add rsync. Rsync is used to copy and synchronize files and directories remotely.
````
      Instead of,  RUN ln -sf ${VENDOR_PATH} ${APP}/current/vendor
      change to, RUN ln -sf ${VENDOR_PATH} ${APP}/shared/vendor
````
* docker-compose:
````bash
(l)$ wget https://gist.githubusercontent.com/dmarczal/585343b16c62f7f061e8d6964639ec4d/raw/063c941f8e7a0be1c9b75e482a15c112c007c2db/docker-compose.yml
````
* Open the docker-compose.yml file, and change the lines:
````yaml
    Instead of,  - ./current/php/local.ini:/usr/local/etc/php/conf.d/local.ini
    change to,   - ./shared/php/server.ini:/usr/local/etc/php/conf.d/server.ini
````
````yaml
	Instead of,  - ./current/mysql/my.cnf:/etc/mysql/my.cnf
	change to,   - ./shared/mysql/my.cnf:/etc/mysql/my.cnf
````
* Create a folder to store the php file:
````bash
    (l)$ mkdir -p deploy/php
    (l)$ cd deploy/php
    (l)$ nano server.ini
````
**Content:**
````
          upload_max_filesize=40M
          post_max_size=40M
          memory_limit=4G
````
* Create a folder to store the mysql file:
````bash
    (l)$ mkdir -p deploy/mysql
    (l)$ cd deploy/mysql
    (l)$ nano my.cnf
````
**Content:**
````
		   [mysqld]
	       general_log = 1
	       general_log_file = /var/lib/mysql/general.log
````
16. Add files created in the production branch, so that the server has access to these files when cloned:
````bash
    (l)$ git add .
    (l)$ git commit -m “commit deploy-production”
    (l)$ git push origin production
````
17. Prepare the deployment, the deploy: prepare command verifies that the releases, shared folders and .dep have been created on the server, if they do not exist, deploy: prepare will create them:
````bash
(l)$ docker-compose exec app php vendor/bin/dep deploy:prepare production -vvv
````
**OBS:**
   deploy_path is the application path, this path is added to the deploy.php file;
	In the shared folder, shared files are stored in all versions;
	The releases folder contains the releases, which would be different versions of the application;
	In .dep, they are metadata used by Deployer.

18. The deploy: setup command is responsible for creating and starting the application containers:
````bash
(l)$ docker-compose exec app php vendor/bin/dep deploy:setup:docker production -vvv
````
19. On the server, go to the /var/www/APP_NAME/shared folder and create an .env file:
````bash
(s) $ nano .env
````
**Content:**
````
    APP_NAME=SM-SEMEC
    APP_ENV=production
    APP_KEY=
    APP_DEBUG=false
    APP_URL=http://semec.tsi.pro.br

    DB_CONNECTION=mysql
    DB_HOST=db-semec
    DB_PORT=3306
    DB_DATABASE=name_database
    DB_USERNAME=user-database
    DB_PASSWORD=password-database  
````
20. Generate application key:
````bash
(l) $ docker-compose exec app php vendor/bin/dep deploy:artisan:key:generate production -vvv
````
21. After everything is set up, just run the command to deploy the application to the server:
````bash
(l)$ docker-compose exec app php vendor/bin/dep deploy production -vvv
````
22. On the server, create the configuration file, APP_NAME (e.g. sm-semec) in the /etc/nginx/sites-available folder:
* Create file:
````bash
(s)$ sudo vim /etc/nginx/sites-available/sm-semec
````
**Content:**
````
      upstream app-semec {
          server 0.0.0.0:9001;
      }
      server {
          listen 80;
          server_name dominio.com;
          error_log  /var/www/sm-semec/shared/logs/nginx-error.log;
          access_log /var/www/sm-semec/shared/logs/nginx-access.log;
          root /var/www/sm-semec/current/public;
      
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Content-Type-Options "nosniff";
      
          index index.html index.htm index.php;
      
          charset utf-8;
      
          location ~\.php$ {
              try_files $uri = 404;
             fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass app-semec;
              fastcgi_index index.php;
              include fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param PATH_INFO $fastcgi_path_info;
          }
      
          location / {
              try_files $uri $uri/ /index.php?$query_string;
          }
      
          location = /favicon.ico { access_log off; log_not_found off; }
          location = /robots.txt  { access_log off; log_not_found off; }
      
          error_page 404 /index.php;
      
          location ~ /\.(?!well-known).* {
              deny all;
          }
      
          client_max_body_size 5M;
          client_body_buffer_size 16k;
      }
````
23. Activate the site by adding a symbolic link to the file created on the activated sites:
````bash
(s)$ sudo ln -sf /etc/nginx/sites-available/sm-semec /etc/nginx/sites-enabled/sm-semec
````
24. Check that everything is correct in the settings made and reload nginx:
````bash
    (s)$ sudo nginx -t
````
````bash
    (s)$ sudo nginx -s reload
````
25. Configure SSL (https), it is a type of digital security that allows encrypted communication between a website and a browser:
Based on How To Secure Nginx with Let's Encrypt, it provides an easy way to install and obtain free SSL certificates, thus allowing encrypted HTTPS on servers.
* Install Certbot, with it you can generate certificates issued by Let's Encrypt:
````bash
(s)$ sudo add-apt-repository ppa:certbot/certbot
````
````bash
(s)$ sudo apt-get update
````
```bash
(s)$ sudo apt-get install python-certbot-nginx
````
* The Nginx plug-in will take care of reconfiguring Nginx and reloading the configuration whenever necessary, it does this by running certbot –nginx, and to specify the name for which the certificate is valid, use -d, when it is the first time it will ask you to add your email:
````bash
(s)$ sudo certbot --nginx -d semec.tsi.pro.br
````
* The certbot adds a script that runs twice a day where it automatically renews any certificate, to test the renewal process just run:
````bash
(s)$ sudo certbot renew –dry-run
````
26. In the /var/www/APP_NAME/shared/.env file, change http to https:
````bash
(s)$ docker-compose exec app php vendor/bin/dep deploy:config:cache production -vvv
````
27. Access the application [https://semec.tsi.pro.br:](https://semec.tsi.pro.br)