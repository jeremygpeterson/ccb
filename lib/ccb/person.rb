module CCB
  class Person < CCB::Base
    def self.search(args={})
      options = args.merge("svc" => "individual_search")
      #options["svc"] = "individual_search"
      options = HashWithIndifferentAccess.new options
      options
    end
  end
end
