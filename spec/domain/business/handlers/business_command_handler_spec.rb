require "spec_helper"

RSpec.describe Domain::Business::Handlers::BusinessCommandHandler do
  let(:repository) { instance_double(AggregateRoot::Repository) }
  let(:handler) { described_class.new(repository) }

  describe "#call" do
    it "appends BusinessCreated to the business stream with command data" do
      command = Domain::Business::Commands::CreateBusiness.new(
        business_id: "biz-123",
        name: "Acme Corp",
        country: "US",
        owner_user_id: "owner-123",
        address: {
          line1: "123 Main St",
          line2: "Suite 4",
          city: "Metropolis",
          postcode: "12345",
          country_code: "US"
        }
      )

      expect(repository).to receive(:store) do |aggregate, stream_name|
        events = aggregate.unpublished_events.to_a
        event = events.first

        expect(event).to be_a(Domain::Business::Events::BusinessCreated)
        expect(event.business_id).to eq("biz-123")
        expect(event.name).to eq("Acme Corp")
        expect(event.country).to eq("US")
        expect(event.owner_user_id).to eq("owner-123")
        expect(event.main_address).to include(
          line1: "123 Main St",
          line2: "Suite 4",
          city: "Metropolis",
          postcode: "12345",
          country_code: "US",
          id: kind_of(String)
        )
        expect(stream_name).to eq("Business-biz-123")
      end

      handler.call(command)
    end
  end
end
