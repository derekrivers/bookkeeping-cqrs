module Domain
  module Business
    module Handlers
      class BusinessCommandHandler
        def initialize(event_store)
          @event_store = event_store
        end

        def call(command)
          business = Domain::Business::Aggregate.new(command.business_id)
          business.create(
            name: command.name,
            country: command.country,
            owner_user_id: command.owner_user_id
          )

          @event_store.append(
            business.unpublished_events,
            stream_name: "Business-#{command.business_id}"
          )
        end
      end
    end
  end
end
