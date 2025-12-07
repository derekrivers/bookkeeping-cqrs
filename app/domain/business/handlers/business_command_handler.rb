require_relative "../aggregate"

module Domain
  module Business
    module Handlers
      class BusinessCommandHandler
        def initialize(repository)
          @repository = repository
        end

        def call(command)
          main_address_id = SecureRandom.uuid
          business = Domain::Business::Aggregate.new(command.business_id)

          business.create(
            name: command.name,
            country: command.country,
            main_address: command.address.merge(id: main_address_id),
            owner_user_id: command.owner_user_id
          )

          @repository.store(business, stream_name(command.business_id))
        end

        private

        def stream_name(id)
          "Business-#{id}"
        end
      end
    end
  end
end
