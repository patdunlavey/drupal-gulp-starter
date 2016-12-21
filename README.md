Drupal Gulp Starter Kit
----

* Manage SASS
* Linters for PHP and JS
* Code style checks for PHP and JS
* Integrate with CircleCI

Requirements
----

* The project contains a `composer.json` file to manage PHP dependencies
  * To get the PHP dependencies run: `composer install`
  * For D7
    * Add an entry to `.gitignore` for the `vendor` directory
  * D8 for the time being we are committing the `vendor` directory to the repo until we can get a build process on CircleCI that builds the artifacts and can deliver to the production server environment
* The project contains a `package.json` file to manage the Node JS dependencies
  * To get the Node dependencies run: `npm install`
  * Add an entry to `.gitignore` for the `node_modules` directory


Usage to run tasks locally
----
* `gulp` (or `gulp watch`)
  * Runs the default `watch` task which are watch sass files
* `gulp check`
  * runs the linters and code style checks for PHP and JS
  * To run tasks individually:
    * `gulp check:phpcs` ~ checks PHP against Drupal standards
    * `gulp check:phplint` ~ checks for strict PHP structure
    * `gulp check:sasslint` ~ checks for SASS coding standards

To Integrate with CircleCI
----
* Configure the `circle.yml` file for your project
