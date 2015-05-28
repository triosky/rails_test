# README

# Testing/developing

- checkout gem
- ``bundle``
- ``cp spec/db/database.example.yml spec/db/database.yml``
- edit database config to fit your needs
- ``rake db:create db:migrate``
- ``rspec`` or ``RSPEC_ALL rspec`` to skip specs filtering 

Rakefile contains part of ActiveRecord tasks useful for maintaining test db.

