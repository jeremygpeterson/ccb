require 'active_support/hash_with_indifferent_access'
module CCB
  class Base
    include HTTParty
    base_uri BASE_URI
    basic_auth(CCBAUTH[:username], CCBAUTH[:password])
  end
end
