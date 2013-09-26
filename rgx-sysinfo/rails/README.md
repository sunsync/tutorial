MOAT IoT Application Example
========
Simple Example Rails Application
--------

This application is built on top of Rails generated application and is already applied Twitter Bootstrap 2.2.2.
The version of Rails used here is 3.2.11.

See [the tutorial](http://dev.yourinventit.com/guides/get-started) to learn more.

The directory structure of this application is as follows:

    |-- app
    |   `-- assets
    |       |-- images
    |       |   `-- bootstrap (B)
    |       |-- javascripts
    |       `-- stylesheets
    |   |-- controllers
    |   |-- helpers
    |   |-- mailers
    |   |-- models (1)
    |   `-- views
    |       |-- dashboard
    |       `-- layouts
    |-- config
    |   |-- environments
    |   |-- initializers (2)
    |   `-- locales
    |-- db
    |-- doc
    |-- lib
    |   `-- tasks
    |-- log
    |-- public
    |-- script
    |-- test
    |   |-- fixtures
    |   |-- functional
    |   |-- integration
    |   |-- performance
    |   `-- unit
    |-- tmp
    |   |-- cache
    |   |-- pids
    |   |-- sessions
    |   `-- sockets
    `-- vendor
        |-- assets
        |   |-- javascripts
        |   |   `-- bootstrap (B)
        |   `-- stylesheets
        |       `-- bootstrap (B)
        `-- plugins

- (1) moat\_* and sys\_* files are basic implementation of MOAT REST client
- (2) constants.rb contains declaration for `applicationId`, `pacakgeId`, `clientId`, and `clientSecret`
- (B) where Twitter Bootstrap files exist
