#require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
require (File.expand_path('./../../../spec_helper', __FILE__))
describe CCB::Person do
  it "must load httparty" do
    CCB::Person.must_include HTTParty
  end
  it "must have the base url set to the CCB API"
    Dish::Player.base_uri.must_equal 'http://api.dribbble.com'
  end
end
