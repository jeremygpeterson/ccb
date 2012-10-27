require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
# require (File.expand_path('./../../../spec_helper', __FILE__))
describe CCB::Session do
  it "must load httparty" do
    CCB::Session.must_include HTTParty
  end
end
