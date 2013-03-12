require 'spec_helper'

describe CCB::Session do
  xit "must inherit from CCB::Base" do
    assert_equal true, CCB::Person.ancestors.include?(CCB::Base)
  end
end
