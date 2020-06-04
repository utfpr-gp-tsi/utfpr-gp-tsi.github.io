---
title: Example of deploy.php
---

## In this example of deploying, commands were used for a laravel app using docker.

1. Add the application name:
````php
set('application', 'sm-semec');
````
2. Add application repository found on github:
````php
set('repository', 'git@github.com:utfpr-gp-tsi/sm-semec.git');
````
3. Allocate TTY to the git clone command, this allows you to enter a password for keys:
````php
set('git_tty', true);
````
* OBS: TTY é um terminal no qual está conectado, quando ativado ele mostrará o terminal do git para obter uma senha.
4. Define how many versions you want to keep the application:
````php
set('keep_releases', 3);
````
5. Set the process execution timeout:
````php
set('default_timeout', 600);
````
6. Files that can be shared with all versions of the project:
````php
add('shared_files', ['.env']);
````
7. Creates a symbolic link, where it is shared with the other versions of the project:
````php
add('shared_dirs', ['logs', 'public/uploads', 'vendor']);
````
8. You need to specify a few things like:
````php
      host('production')
       	->hostname('161.35.122.229')
       	->user('deployer')
       	->port(22)
       	->identityFile('/var/www/.ssh/id_rsa')
       	->stage('production')
           ->set('deploy_path', '/var/www/{{application}}')
           ->set('branch','production'); 
````
**Where**
* You must define a host to deploy:
`host('production')`
* Add the IP server that will be used:
`→hostname('161.35.122.229')`
* User responsible for the deployment (must never be root):
`→user('deployer')`
* Port you are using:
`→port(22)`
* File must contain information about domains and how to connect:
`→identityFile('/var/www/.ssh/id_rsa')`
* Host stage:
`→stage('production')`
* Path where the application is located (leave application saved locally in / var / www):
`->set('deploy_path', '/var/www/{{application}}')`
* Branch production used in the deploy:
`→set('branch','production');`
9. Upload the directories by sending to the server:
````php
       task('deploy:cp-docker-files', function () {
           upload('deploy/production/', "{{deploy_path}}");
           upload('deploy/php/', "{{deploy_path}}/shared/php/");
           upload('deploy/mysql/', "{{deploy_path}}/shared/mysql/");
       })→onStage('production');
````
**OBS** Stage being used to deploy: `→onStage('production');`
10. Commands related to containers:
````php
       task('deploy:build-containers', function () {
          run('cd {{deploy_path}} && docker-compose stop app-semec');
          run('cd {{deploy_path}} && docker-compose build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) app-semec');
       	});
````
**Where:**
* Stop the containers from running without removal:
    `run('cd {{deploy_path}} && docker-compose stop app-semec');`
* Create the application container:
    `run('cd {{deploy_path}} && docker-compose build --build-arg USER_ID=$(id -u) --build-arg 
      GROUP_ID=$(id -g) app-semec');
	});`
11. Issue a single command to start all containers, create volumes, configure and connect as networks
````php
task('deploy:up-containers', function () { run('cd {{deploy_path}} && docker-compose up -d'); });
````
12. Displays the containers:
````php
task('deploy:containers-ps', function () { run('cd {{deploy_path}} && docker-compose ps'); });
````
13. Command to perform docker-related tasks:
````php
    task('deploy:setup:docker', [
           'deploy:cp-docker-files',
           'deploy:build-containers',
           'deploy:up-containers',
           'deploy:containers-ps'
       ]);
````
14. To install all packages and libraries, where optimize-autoloader speeds up automatic loading in the application:
````php
     task('deploy:composer:install', function () {
       run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec composer install –   no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --no-suggest --optimize-autoloader');
       });
````
15. Generate a key for the project:
````php
     task('deploy:artisan:key:generate', function () {
       run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec php artisan key:generate');
       });
````
16. Cache these settings in a file, which will increase the application loading speed:
````php
     task('deploy:config:cache', function () {
       run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec php artisan config:cache');
       });
````
17. Perform the migrations of the database tables:
````php
     task('deploy:migrate', function () {
	run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec php artisan migrate –	force');
	});
````
18. Run the seeds:
````php
     task('deploy:seed', function () {
       run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec php artisan db:seed –force');
       });
````
19. Install the packages and dependencies with npm install, then load the application's sass files:
````php
     task('deploy:assets', function () {
	run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec 	npm install'); 
	run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec 	npm run production');
	});
````
20. Run the command to clear the routes and cache from the application view:
````php
     task('deploy:cache', function () {
	 run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec 	php artisan route:cache');
	 run('cd {{deploy_path}} && docker-compose exec -T -w {{release_path}} app-semec 	php artisan view:cache');
	});
````
21. Stops the user process, causing the user to log off:
````php
     task('deploy:reload:php', function () {
           run('cd {{deploy_path}} && docker-compose exec -T app-semec kill -USR2 1');
});
````
22. Reload nginx settings after modification:
````php
     task('deploy:reload:nginx', function () {
          run('sudo nginx -s reload');
      });task('deploy:reload:nginx', function () {
          run('sudo nginx -s reload');
      });
````
23. After completing the custom tasks, add them to the deploy task:
````php
     task('deploy', [
           'deploy:lock',
           'deploy:release',
           'deploy:update_code',
           'deploy:shared',
           'deploy:clear_paths',
           'deploy:composer:install',
           'deploy:config:cache',
           'deploy:migrate',
           'deploy:seed',
           'deploy:assets',
           'deploy:cache',
           'deploy:reload:php',
           'deploy:reload:nginx',
           'deploy:symlink',
           'deploy:unlock',
           'cleanup',
           'success'
       ]);
````
24. Delete release files like deploy.log that is on the server:
````php
after('deploy:failed', 'deploy:unlock');
````
