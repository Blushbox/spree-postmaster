
**This extension is in beta.**

SpreePostmaster
===============

A Spree extension to integrate with postmaster.io API.

Todo
----

* Configure the carrier & shipment variables based on selected shipping method (temporarily fixed to usps / 2DAY)
* Is it possible to use length/weight/height from product(s) if available? (temporarily only using configured defaults from within admin panel)
* Add Specs
* Address verification
* Rate calculation
* Notifications on delivery, etc (webhooks)

Installation
------------

Add this to your Gemfile

    gem "spree_postmaster", github: "blushbox/spree-postmaster", branch: 'master'

Install the database migrations 

    rake spree_postmaster:install:migrations
    rale db:migrate

Configuration
-------------

Go to the admin configuration tab and click on postmaster settings link from the menu on the right, fill in API key and desired default values.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2014 BlushBox, released under the New BSD License
