CCB - Ruby Wrapper for the Church Community Builder API
===

This will eventually become a gem for use with the Church Community Builder API.

To use the API you must be an active CCB customer or have access to a demo site.
modify your config/ccb.yml file with the appropriate information. The
default environment is development.

Usage
====

command line:
```
cp config/ccb_template.yml config/ccb.yml
```
edit config/ccb.yml to use your API user account and specify the API location for your church

If you use RVM you may want to create a .rvmrc file:
```
rvm use 1.9.3-p194@ccb --create
```

Get you gems loaded:
```
bundle
```

irb/pry:

```
load "./lib/ccb.rb"
person = CCB::Person.find(:all).first
person.full_name #=> "First Last"
person.groups #=> returns an array of associated groups
person2 = CCB::Person.create(:first_name => "Test User", :last_name => "From API") #=> Note: CCB does not have a purge/delete function for people. Don't create unnecessary profiles.
person2.first_name #=> "Test User"

CCB::Group.search #=> An array of all groups
```

