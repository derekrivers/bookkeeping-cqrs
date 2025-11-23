module Domain
  module Business
    module Commands
      class CreateBusiness
        attr_reader :business_id, :name, :country, :owner_user_id

        def initialize(business_id:, name:, country:, owner_user_id:)
          @business_id = business_id
          @name = name
          @country = country
          @owner_user_id = owner_user_id
        end
      end
    end
  end
end
