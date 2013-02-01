require 'active_support/hash_with_indifferent_access'
module CCB
  class Base

    include HTTParty
    base_uri BASE_URI
    basic_auth(CCBAUTH[:username], CCBAUTH[:password])

    def self.send_data(options,data)
      options = options.collect {|a,b| "#{a}=#{b}"}.join("&")
      response = self.post(self.base_uri + "?" + options, :body => data )
    end

    def self.request(options,fields=[])
      options = HashWithIndifferentAccess.new options
      fields.dup.each do |key|
        next if key == "srv"
        options.delete key unless fields.include?(key)
      end
      response = self.get(self.base_uri + "?" + options.collect {|a,b| "#{a}=#{b}"}.join("&") )
      response = response["ccb_api"]["response"]
      response = response.values[-1] if response.respond_to?(:values)
      count = response.delete("count").to_i if response.respond_to? :delete
      if count > 0
        response = response[response.keys.first]
        if response.is_a? Array
            response = response.collect {|item| self.from_api(item)}
            return response
        else
            return self.from_api(response)
        end
        return nil
      else
        return response
      end
    end

    def initialize(args={})
      fields = args.keys
      fields.each do |field_name|
        send(:instance_variable_set,"@#{field_name.to_s}", args[field_name]) if self.respond_to? field_name
      end
      @info = args[:info] || {}
    end

    def self.from_api(args={})
      new_args = {}
      args.dup.keys.each do |key|
        new_args[key.to_sym] = args.delete(key) if self.method_defined?(key.to_sym)
      end
      args = args.merge(new_args[:info]) if new_args[:info]
      new_args[:info] = args
      return self.new(new_args)
    end
  end
end
