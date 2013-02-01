module CCB
  class Person::Attendance < CCB::Base
    attr_accessor :event, :group, :occurence, :name, :person_id, :attendance

    def initialize(args={})
      super
      @person_id = @info.delete "id"
      @attendance = @info["attendances"].collect do |k,att|
        {event_id: att["event"].delete("id"), event_name: att["event"].delete("__content__"), group_id: att["group"].delete("id"), group_name: att["group"].delete("__content__"), occurrence: att.delete("occurrence")}
      end
      @info = {}
    end

  end
end
