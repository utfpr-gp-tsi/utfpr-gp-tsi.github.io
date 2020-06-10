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
            {% assign arr = doc.url | split:"/" %}
    
            {% if arr.size == 4 %}
                <h5>&#9642;&nbsp; <a href="{{ doc.url | prepend: site.baseurl }}">{{ doc.title }}</a></h5>
            {% else %}
                {% for i in (5..arr.size) %}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                {% endfor %}
                
                &#9702;&nbsp; <a href="{{ doc.url | prepend: site.baseurl }}">{{ doc.title }}</a>
            {% endif %}

        </div>
    {% endfor %}
</div>

## Contributors

|            Contributors             |                    GitHub                   |
| :---------------------------------- | :------------------------------------------ |
| ![Amanda](https://github.com/AmandaCarolyneDeLima.png?size=20) Amanda Carolyne De Lima             | [https://github.com/AmandaCarolyneDeLima](https://github.com/AmandaCarolyneDeLima)                 |
| ![Eduarda](https://github.com/Dudalara.png?size=20) Eduarda Lara                      | [https://github.com/Dudalara](https://github.com/Dudalara)            | 
| ![Tais](https://github.com/TaisHryssai.png?size=20) Tais Michele Hryssai Da Luz        | [https://github.com/TaisHryssai](https://github.com/TaisHryssai)                 |

## Maintainers

|             Maintainers             |                    GitHub                   |
| :---------------------------------- | :------------------------------------------ |
| ![Andres](https://github.com/andresjesse.png?size=20) Andres Jesse Porfirio                       | [https://github.com/andresjesse](https://github.com/andresjesse)
| ![Diego](https://github.com/dmarczal.png?size=20) Diego Marczal                       | [https://github.com/dmarczal](https://github.com/dmarczal)