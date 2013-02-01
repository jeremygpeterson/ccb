module CCB
  class UserGroup < CCB::Base
    attr_accessor :id, :name, :receive_email_from_group, :receive_sms_from_group, :notify_comments, :user_id

  end
end
