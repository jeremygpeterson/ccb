#require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
require (File.expand_path('./../../../spec_helper', __FILE__))
describe CCB::Person do
  it "must inherit from CCB::Base" do
    assert_equal true, CCB::Person.ancestors.include?(CCB::Base)
  end

end
