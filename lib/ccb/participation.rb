module CCB

	class Participation
		attr_accessor :person_id, :first_name, :last_name, :full_name, :email, :status, :phones, :sms

		def initialize(args={})
  	  args.each do |k,v|
	  		send(:instance_variable_set, "@#{k}", v) if respond_to? k
  	  end
		end
	end

end