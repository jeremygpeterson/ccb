require 'httparty'
require 'active_support'

RAILS_ENV = "development" unless defined? RAILS_ENV

def refresh_ccb
  load __FILE__
end

config = YAML.load(File.read("./config/ccb.yml"))[RAILS_ENV]
user = config["username"]
pass = config["password"]
BASE_URI = config["url"] unless defined? BASE_URI
CCBAUTH = {:username => user, :password => pass} unless defined? CCBAUTH
# CCB_AUTHORIZE can now be included in the Authorize HTTP header
CCB_AUTHORIZE = Base64.encode64("#{user}:#{pass}").strip unless defined? CCB_AUTHORIZE

# HTTParty.get(site, :basic_auth => CCBAUTH))

require File.dirname(__FILE__) + '/ccb/base.rb'
Dir[File.dirname(__FILE__) + '/ccb/*.rb'].each do |file|
    #require file
    load file
end
