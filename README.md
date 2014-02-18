
**This extension is in beta.**

SpreePostmaster
===============

A Spree extension to integrate with postmaster.io API.


Installation
-------

Add this to your Gemfile

    gem "spree_postmaster", github: "blushbox/spree-postmaster", branch: 'master'

Install the database migrations

    rake spree_postmaster:install:migrations


Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 BlushBox, released under the New BSD License
