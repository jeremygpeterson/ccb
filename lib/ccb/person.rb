module CCB
  class Person < CCB::Base
    attr_accessor :id, :first_name, :last_name, :phone, :email, :street_address, :city, :state, :zip, :info, :image, :family_position, :giving_number, :gender, :birthday, :anniversary, :active, :created, :modified, :receive_email_from_church, :marital_status, :phones
    def initialize(args={})
      super
    end

    def full_name
      first_name + " " + last_name
    end

    def self.from_api(args={})
      super
    end

    def self.search(args={})
      fields = %w{first_name last_name phone email street_address city state zip}.collect(&:to_sym)
      args.dup.keys.each do |key|
        args.delete key unless fields.include?(key)
      end
      raise "Please include one of #{fields.join(', ')}" if args.keys.empty?
      options = args.merge("srv" => "individual_search")
      #options["svc"] = "individual_search"
      options = HashWithIndifferentAccess.new options
      response = self.request(options)
    end
  end
end
