module CCB
  class Event < CCB::Base
    attr_accessor :id, :name, :start_datetime, :start_date,
      :leader_notes, :start_time, :end_date, :end_time, :timezone,
      :end_datetime, :recurrence_description, :group, :organizer, :location,
      :registration, :resources, :exceptions, :setup, :creator, :modifier,
      :created, :modified

    SRV = {
      :search => "event_profiles"
    } unless defined? SRV

    def self.search(args={})
      if args[:since]
        value = args.delete :since
        value = Time.parse(value.to_s)
        args["modified_since"] = value.strftime("%Y-%m-%d")
      end
      fields = []
      args["srv"] = SRV[__method__]
      response = self.request(args,fields)
    end

    def creator
      value = from_ccb_hash(__method__, "id")
      return CCB::Person.find(:id => value) if value
    end

    def organizer
      value = from_ccb_hash(__method__, "id")
      return CCB::Person.find(:id => value) if value
    end

    def modifier
      value = from_ccb_hash(__method__, "id")
      return CCB::Person.find(:id => value) if value
    end

  end
end
