module CCB
  class Country
  	attr_accessor :name, :code

  	def initialize(args)
  	  @name = args[:name]
  	  @code = args[:code]
  	end

  	def self.from_api(data)
  	  args = {:name => data["__content__"], :code => data["code"]}
  	  self.new(args)
  	end

  end
end