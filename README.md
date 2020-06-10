### Access tutorial page through github pages
[https://utfpr-gp-tsi.github.io](https://utfpr-gp-tsi.github.io)


<img src="assets/img/deploy-laravel-aplicattion.png" alt="Deploy">

## Usage

### 1. Get the code

You can clone the repository right to where you want to host the docs:

```bash
git clone https://github.com/utfpr-gp-tsi/utfpr-gp-tsi.github.io.git
```

### 2. Customize

To edit configuration values, customize the [_config.yml](https://github.com/vsoch/docsy-jekyll/blob/master/_config.yml).
To add pages, write them into the [pages](https://github.com/vsoch/docsy-jekyll/blob/master/pages) folder. 
You define urls based on the `permalink` attribute in your pages,
and then add them to the navigation by adding to the content of [_data/toc.myl](https://github.com/vsoch/docsy-jekyll/blob/master/_data/toc.yml).
The top navigation is controlled by [_data/navigation.yml](https://github.com/vsoch/docsy-jekyll/blob/master/_data/navigation.yml)

### 3. Options

Most of the configuration values in the [_config.yml](https://github.com/vsoch/docsy-jekyll/blob/master/_config.yml) are self explanatory,
and for more details, see the [getting started page](https://vsoch.github.io/docsy-jekyll/docs/getting-started)
rendered on the site.

### 4. Serve

Depending on how you installed jekyll:

```bash
jekyll serve
# or
bundle exec jekyll serve
```

### 5. Run as a container in dev or prod

#### Software Dependencies

If you want to run docsy jekyll via a container for development (dev) or production (prod) you can use containers. This approach requires installing [docker-ce](https://docs.docker.com/engine/install/ubuntu/) and [docker-compose](https://docs.docker.com/compose/install/). 

#### Customization

Note that the [docker-compose.yml](docker-compose.yml) file is using the [jekyll/jekyll:3.8](https://hub.docker.com/r/jekyll/jekyll/tags) image. If you want to make your build more reproducible, you can specify a particular version for jekyll (tag). Note that at the development time of writing this documentation, the latest was tag 4.0.0,
and it [had a bug](https://github.com/fastai/fastpages/issues/267#issuecomment-620612896) that prevented the server from deploying.

If you are deploying a container to production, you should remove the line to
mount the bundles directory to the host in the docker-compose.yml. Change:

```yaml
    volumes: 
      - "./:/srv/jekyll"
      - "./vendor/bundle:/usr/local/bundle"
      # remove "./vendor/bundle:/usr/local/bundle" volume when deploying in production
```

to:

```yaml
    volumes: 
      - "./:/srv/jekyll"
```

This additional volume is optimal for development so you can cache the bundle dependencies,
but should be removed for production. 

#### Start Container

Once your docker-compose to download the base container and bring up the server:

```bash
docker-compose up -d
```

You can then open your browser to [http://localhost:4000/](http://localhost:4000/)
to see the server running.

> Node : changes `baseurl: ""` in _config.yml  when you are running in local and prod according to the requirement.


### Useful links for editing this project

http://jmcglone.com/guides/github-pages/

https://vsoch.github.io/docsy-jekyll/docs/getting-started#getting-started

https://shopify.github.io/liquid/basics/truthy-and-falsy/

https://gist.github.com/JJediny/a466eed62cee30ad45e2

https://packetlife.net/media/library/16/Markdown.pdf