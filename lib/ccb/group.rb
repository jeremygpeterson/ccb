module CCB
  class Group < CCB::Base
    attr_accessor :id, :name, :owner_email_primary, :status_id, :messaging_type, :membership_type, :description

    SRV = {
      :search => "group_search",
      :create => "create_group"
    } unless defined? SRV

    def self.search(args={})
      fields = %w{name area_id childcare meet_day_id meet_time_id department_id type_id udf_pulldown_1_id udf_pulldown_2_id udf_pulldown_3_id limit_records_start limit_records_per_page order_by_1 order_by_2 order_by_3 order_by_1_sort order_by_2_sort order_by_3_sort}.collect(&:to_sym)
      args["srv"] = SRV[__method__]
      response = self.request(args,fields)
    end

    def self.create(args={})
      options = {"srv" => SRV[__method__]}
      response = send_data(options,args)
      self.from_api(response["ccb_api"]["response"]["groups"]["group"])
    end
  end
end
