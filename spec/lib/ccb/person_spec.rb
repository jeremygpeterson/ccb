require 'spec_helper'

describe CCB::Person do
  def body(results)
    last_response = {'results' => {:results => results, :count => results.count}}
    body = {:ccb_api => {:response => last_response}}
    MultiJson.encode(body)
  end

  let(:results) {
    {
      :id => 12345,
      :first_name => 'Jeremy',
      :last_name => 'Peterson',
      :email => 'jp@nobody.com',
      :street_address => 'my address',
      :city => 'city',
      :state => 'state',
      :zip => '11111',
      :info => {'notes' => 'nice guy'},
      :image => 'image.jpg',
      :family_position => '???',
      :giving_number => 987,
      :gender => 'male',
      :birthday => '???',
      :anniversary => '????',
      :active => true,
      :created => '?????',
      :modified => '??????',
      :receive_email_from_church => true,
      :marital_status => '???????',
      :phones => '?????????',
    }
  }

  let(:person) {
    CCB::Person.all.first
  }

  before :each do
    stub_request(:get, "https://USERNAME:PASSWORD@demochurch.ccbchurch.com/api.php?srv=individual_profiles").
      to_return(:status => 200, :body => body([results]), :headers => {:content_type => "application/json"})
  end

  {
    :id => 12345,
    :first_name => 'Jeremy',
    :last_name => 'Peterson',
    :email => 'jp@nobody.com',
    :street_address => 'my address',
    :city => 'city',
    :state => 'state',
    :zip => '11111',
    :info => {'notes' => 'nice guy'},
    :image => 'image.jpg',
    :family_position => '???',
    :giving_number => 987,
    :gender => 'male',
    :birthday => '???',
    :anniversary => '????',
    :active => true,
    :created => '?????',
    :modified => '??????',
    :receive_email_from_church => true,
    :marital_status => '???????',
    :phones => '?????????',
  }.each do |field, value|
    it "find :all returns fields" do
      person.send(field).should == value
    end
  end

  it "has full name" do
    person.full_name.should == 'Jeremy Peterson'
  end

  xit "attendance calls Person::Attendance" do
    attendance = mock
    CCB::Person::Attendance.should_receive(:request).with("srv" => 'individual_attendance', "individual_id" => 12345).and_return(attendance)
    person.attendance.should == attendance
  end

  xit "group calls groups" do
    person.groups
  end

  it "persisted? false" do
    person.persisted?.should be_false
  end

  #merged_profiles
  #create
  #save
  #groups
  #destroy
  #login
  #all
  #find
  #from_micr
  #search
  #from_id
  # private update
end
