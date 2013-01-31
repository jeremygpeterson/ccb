CCB - Ruby Wrapper for the Church Community Builder API
===

This will eventually become a gem for use with the Church Community Builder API.

To use the API you must be an active CCB customer or have access to a demo site.
modify your config/ccb.yml file with the appropriate information. The
default environment is development.

Usage
====

irb/pry:
```load "./lib/ccb.rb"
CCB::Person.search(:first_name => "e")
```

