module CCB
  class Position < CCB::Base
  	attr_accessor :id, :name, :description, :listed, :scheduled, :owner, :creator, :created, :modified, :position_type, :campus, :group_id, :maximum_limit, :filling_currently, :inactive, :group_name, :modifier, :participants
    #tracking_methods = [:first_name, :last_name, :email, :street_address, :city, :state, :zip, :info, :image, :family_position, :giving_number, :gender, :birthday, :anniversary, :active, :receive_email_from_church, :marital_status]
	#define_attribute_methods  tracking_methods

	# tracking_methods.each do |method|
 #      assign_attribute method
 #  	end

    SRV = {
      :list => "position_list"
    } unless defined? SRV

    def initialize(args={})
      super
      @created = Time.parse(@created) if @created
      @modified = Time.parse(@modified) if @modified
      @participants.each do |part|
      	part = CCB::Participation.new(part)
      end

    end

    def self.from_api(args)
      args = args["ccb_api"]["response"]["positions"]["position"] if args.keys.include?("ccb_api")
      super
    end

    def self.add_person_to_position(args={})
      CCB::Person.add_position(args)
    end

  	def self.list
	  options = {"srv" => SRV[__method__]}
      response = send_data(options,{})
  	end



  end #class
end #module