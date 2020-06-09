---
layout: page
title: UTFPR-GP TSI - Tutorials Repository
permalink: /
---

# UTFPR-GP TSI - Tutorials Repository

Welcome to the Tutorials Page for UTFPR-GP TSI projects. In this website you'll find guides and tutorials regarding tools and technologies employed in our projects, among other useful commands, samples and code snippets.

## Tutorials Available

<div class="section-index">
    <hr class="panel-line">
    {% for doc in site.docs  %}
    <div class="entry">
    <a href="{{ doc.url | prepend: site.baseurl }}">{{ doc.title }}</a>
    </div>{% endfor %}
</div>

[//]: TODO: remove following:
[//]: ## Tutorials Available
[//]: * [Deploy a laravel 7.x application using deployer and docker](docs/tutorials/deploy-laravel/deploy-aplicattion-laravel)
[//]: * [Debugbar](docs/tutorials/debugbar/tutorial-debugbar)
[//]: * [PHP static code analysis tools](docs/tutorials/code-analysis/tutorial-analysis)
[//]: * [Tinker](docs/tutorials/tinker/tutorial-tinker)
[//]: * [Configuration for sending email](docs/tutorials/email/tutorial-email)
[//]: * [Laravel with Docker](docs/tutorials/laravel-docker/tutorial-laravel-docker)

## Contributors

|            Contributors             |                    GitHub                   |
| :---------------------------------- | :------------------------------------------ |
| ![Amanda](https://github.com/AmandaCarolyneDeLima.png?size=20) Amanda Carolyne De Lima             | https://github.com/AmandaCarolyneDeLima                 |
| ![Eduarda](https://github.com/Dudalara.png?size=20) Eduarda Lara                      | https://github.com/Dudalara            | 
| ![Tais](https://github.com/TaisHryssai.png?size=20) Tais Michele Hryssai Da Luz        | https://github.com/TaisHryssai                 |

## Maintainers

|             Maintainers             |                    GitHub                   |
| :---------------------------------- | :------------------------------------------ |
| ![Andres](https://github.com/andresjesse.png?size=20) Andres Jesse Porfirio                       | https://github.com/andresjesse
| ![Diego](https://github.com/dmarczal.png?size=20) Diego Marczal                       | https://github.com/dmarczal