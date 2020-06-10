---
title: PHP static code analysis tools
---

# PHP static code analysis tools

## squizlabs-standard

To eliminate some obstacles, we can use static code analysis tools that enforce coding standards, detect common errors and block cleaning.

* ### **Install**

````bash
composer require --dev squizlabs/php_codesniffer
````

* ### **Create a rules file (phpcs.xml)**

At the root of the project, create a page with the following code, and save it as phpcs.xml.

````xml
<?xml version="1.0"?>
<!-- Ruleset name →
<ruleset name="Custom_PSR12">
<!-- Description →
<description>Custom ruleset Based on PSR12</description>
<!-- Rule to be referenced (`PSR12`) →
<rule ref="PSR12"/>
<!-- Specify extensions (.php) →
<arg name="extensions" value="php"/>
<!--Color the result output →
<arg name="colors"/> <!--Display progress (-p)-→
<!--Display violation rules in error information (-s)-→
<arg value="ps"/>
<!-- Directories to exclude from the check (for Laravel) →
<exclude-pattern>/bootstrap/</exclude-pattern>
<exclude-pattern>/config/</exclude-pattern>
<exclude-pattern>/database/</exclude-pattern>
<exclude-pattern>/node_modules/</exclude-pattern>
<exclude-pattern>/public/</exclude-pattern>
<exclude-pattern>/resources/</exclude-pattern>
<exclude-pattern>/routes/</exclude-pattern>
<exclude-pattern>/storage/</exclude-pattern>
<exclude-pattern>/vendor/</exclude-pattern>
</ruleset>
````

* ### **Execution**

````
vendor\bin\phpcs -- standard=phpcs.xml .
````
-----------------------------


## phpstan

Analyze each line statically for problems (number of arguments, type mismatch etc.) before running.


* ### **Install**
````
composer require --dev phpstan/phpstan
````
* ### **Execution**
````
vendor/bin/phpstan analyse ./app
````

------------------------------


## larastan

When PHPStan is used with Laravel, a large number of errors are generated by static calls, etc., to be covered.

* ### **Install**
````
composer require --dev nunomaduro/larastan
````

* ### **Create a rules file (phpstan.neon)**

````
includes:
- ./vendor/nunomaduro/larastan/extension.neon
````

* ### **Execution**
````
php artisan code:analyse
````

------------------------------

These commands can be defined in the script section of composer.json as shortcuts and facilitate use instead of long commands.
````json
"scripts": {
"phpcs": [
"./vendor/bin/phpcs --standard = phpcs.xml ./"
],
"phpmd": [
"./vendor/bin/phpmd app, testa o texto phpmd.xml "
],
" phpstan ": [
" @ código artesanal do php : analise --level = max --paths = app, testes "
],
" analise ": [
" @phpcs ",
" @phpmd ",
" @phpstan "
]
}
````

### **Conclusion**
The static analysis tool is undeniably a great help in solving the problem maintenance of large software projects, while you can focus on essential development. You can also do this in the CI before deployments.