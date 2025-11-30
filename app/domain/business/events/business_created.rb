require "rails_event_store"

module Domain
  module Business
    module Events
      class BusinessCreated < RailsEventStore::Event
        def business_id
          data[:business_id]
        end

        def name
          data[:name]
        end

        def country
          data[:country]
        end

        def owner_user_id
          data[:owner_user_id]
        end
      end
    end
  end
end
