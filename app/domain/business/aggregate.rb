require "aggregate_root"

module Domain
  module Business
    class Aggregate
      include AggregateRoot

      def initialize(id)
        @id = id
        @created = false
      end

      def create(name:, country:, owner_user_id:)
        raise "Already created" if @created

        apply Domain::Business::Events::BusinessCreated.new(
          data: {
            business_id: @id,
            name: name,
            country: country,
            owner_user_id: owner_user_id
          }
        )
      end

      on Domain::Business::Events::BusinessCreated do |event|
        @id = event.business_id
        @name = event.name
        @country = event.country
        @owner_user_id = event.owner_user_id
        @created = true
      end
    end
  end
end
