---
title: Tutorial Debugbar
---

# Debugbar

The debugbar is a package to integrate the PHP debug bar with laravel, making it possible to check what is happening when accessing the pages.

### **Installation**


1. In the terminal, go to the project location and install the packages:
````bash
composer require barryvdh/laravel-debugbar –dev
````
2. In the project, open config / app.php and then 'suppliers':
````php
Barryvdh\Debugbar\ServiceProvider::class,
````
3. Still in config / app.php, in 'aliases':
````php
'Debugbar' => Barryvdh\Debugbar\Facade::class,
````
4. Copy the configuration of the installed package to your local configuration with the command:
````bash
php artisan vendor:publish –provider="Barryvdh\Debugbar\ServiceProvider"
````

### **Functions**

* Messages

Provides a way to log messages, compatible with the PSR-3 logger (debugging, information, warning, error, critical, alert, emergency).
````
Debugbar::info($object);
Debugbar::error(‘Error!’);
Debugbar::warning(‘Watch out ….’);
Debugbar::addMessage(‘Another message’, ‘mylabel’);
````
**Where for example:**
Adding Debugbar :: info ($ object); in the code it will show everything related to $ object in the debug bar;

* TimeData

It provides a way to record the total execution time, as well as to take "action" (that is, to measure the execution time of a specific operation).
<img src="/assets/img/debugbar-timeData.png" alt="request">

* Exceptions

Show exceptions, when added next to a part of the code where there are possibilities to find exceptions:
````
$debugbar->addCollector(new DebugBar\DataCollector\ExceptionsCollector()); 
 try { throw new Exception('foobar');
 } catch (Exception $e) { 
$debugbar['exceptions']→addException($e);
 }
````
* Views

Shows all the blades being used on the page being displayed.
<img src="/assets/img/debugbar-views.png" alt="request">

* Route

Shows the route that is being used, what type of request is GET or POST, from which controller and method it is being called:
<img src="/assets/img/debugbar-route.png" alt="request">

* Queries

In the debug bar under Queries, all queries from the database are displayed.
<img src="/assets/img/debugbar-queries.png" alt="request">

* Request

It brings some information related to the session, and requests made.
<img src="/assets/img/debugbar-request.png" alt="request">

The debugging bar also has other information such as version, type of request, memory used, duration of the request. Clicking on the folder icon on the right side of the bar it will show the requests made.