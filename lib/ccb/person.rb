module CCB
  class Person < CCB::Base
    attr_accessor :id, :first_name, :last_name, :phone, :email, :street_address, :city, :state, :zip, :info, :image, :family_position, :giving_number, :gender, :birthday, :anniversary, :active, :created, :modified, :receive_email_from_church, :marital_status, :phones, :attendance, :addresses

    tracking_methods = [:first_name, :last_name, :email, :street_address, :city, :state, :zip, :info, :image, :family_position, :giving_number, :gender, :birthday, :anniversary, :active, :receive_email_from_church, :marital_status]
    #define_attribute_methods  tracking_methods
    tracking_methods.each do |method|
      assign_attribute method
    end

    SRV = {
      :search => "individual_search",
      :groups => "individual_groups",
      :attendance => "individual_attendance",
      :create => "create_individual",
      :login => "individual_id_from_login_password",
      :from_id => "individual_profile_from_id",
      :all => "individual_profiles",
      :destroy => "individual_inactivate",
      :from_micr => "individual_profile_from_micr",
      :update => "update_individual",
      :add_position => "add_individual_to_position",
      :merged_profiles => "merged_individuals"
    } unless defined? SRV

    def initialize(args={})
      super
      # parse the addresses returned in the API
      unless @addresses.blank?
        addrs = @addresses.dup
        @addresses = []
        addrs.each do |k,addr|
          puts addr[0].inspect
          @addresses << CCB::Address.from_api(addr[0])
        end
      end
    end

    def mailing_address
      addresses.detect {|addr| addr.type == "mailing"}
    end

    def self.merged_profiles(args={})
      svc = {"srv" => SRV[__method__]}
      args = args.merge svc
      response = request(args)
      #self.from_api(response["ccb_api"]["response"]["individuals"]["individual"])
      return response
    end

    def self.create(args={})
      options = {"srv" => SRV[__method__]}
      response = send_data(options,args)
      self.from_api(response["ccb_api"]["response"]["individuals"]["individual"])
    end

    def full_name
      first_name + " " + last_name
    end

    def attendance
      args = {"srv" => SRV[__method__], "individual_id" => self.id}
      response = CCB::Person::Attendance.request(args)
      retval = response
    end

    def persisted?
      false
    end

    def save
      if valid?
        if id && created && changed?
          retval = update
          @previously_changed = changes
          @changed_attributes.clear
          return retval
        elsif id.nil?
          @changed_attributes.clear
          args = {}
          instance_variables.each do |var|
            var = var.to_s
            ignored_atts = %w{@errors @info @changed_attributes @validation_context}
            next if ignored_atts.include?(var)
            key = var[1..-1]
            args[key] = instance_variable_get(var)
          end
          @previously_changed = changes
          @changed_attributes.clear
          return self.class.create(args)
        end
      else
      end
    end

    def self.add_position(args)
      # status values are: add, requesting, undecided, declined, informed
      raise "status, person_id and position_id are both requried" unless [:status, :person_id, :position_id].all? {|k| args.keys.include?(k)}
      args["id"] = args.delete "person_id"
      options = {"srv" => SRV[__method__]}
      response = send_data(options,args)
    end

    def add_position(position_id)
      position_id = position_id.id if position_id.is_a?(CCB::Position)
      self.class.add_position(:person_id => self.id, :position_id => position_id)
    end

    def groups
      args = {"srv" => SRV[__method__], "individual_id" => self.id}
      response = self.class.request(args)
      retval = response.instance_variable_get("@groups")["group"].collect do |g|
        CCB::UserGroup.from_api(g)
      end
      retval.each {|g| g.user_id = id}
      retval
    end

    def self.destroy(id,confirmation=false)
      raise "Confirmation must be set to true: destroy(id,true)" unless confirmation == true
      args = {"individual_id" => id}
      args["srv"] = SRV[__method__]
      puts args.inspect
      response = self.request(args)

    end

    def self.login(args={})
      args = args.select {|k,v| [:username,:password].include?(k)}
      args[:login] = args.delete :username
      args["srv"] = SRV[__method__]
      if args[:login] && args[:password]
        response = self.request(args)
        return self.from_id(response.id)
      else
        return nil
      end
      args
    end

    def self.all(since=nil)
      args = {"srv" => SRV[__method__]}
      response = self.request(args)
    end

    def self.find(args={})
      if args.is_a?(Symbol) && args == :all
        return self.all
      elsif args.is_a?(Hash) && args[:id]
        return self.from_id(args[:id])
      elsif args.is_a?(Hash) && (args[:routing_number] || args[:account_number])
        return self.from_micr(args)
      else
        return self.search(args)
      end
    end

    def self.from_micr(args={})
      fields = %w{routing_number account_number}.collect(&:to_sym)
      raise "Please include both of #{fields.join(', ')}" unless [args.keys].flatten.sort == fields.sort
      args["srv"] = SRV[__method__]
      response = self.request(args, fields)
    end

    def self.search(args={})
      fields = %w{first_name last_name phone email street_address city state zip}.collect(&:to_sym)
      raise "Please include one of #{fields.join(', ')}" if args.keys.empty?
      args["srv"] = SRV[__method__]
      response = self.request(args, fields)
    end

    def self.from_id(id)
      fields = %w{id}
      id = id.to_s
      args = {}
      args["srv"] = SRV[__method__]
      args["individual_id"] = id
      response = self.request(args, fields)
    end

  private

    def update
      args = {"srv" => SRV[__method__], "individual_id" => self.id}
      body = {}
      changes.collect do |k,v|
        body[k] = v[1]
      end
      response = self.class.send_data(args,body)
      self.class.from_api(response["ccb_api"]["response"]["individuals"]["individual"])
    end

  end
end
