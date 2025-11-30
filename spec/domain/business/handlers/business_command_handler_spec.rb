require "spec_helper"

RSpec.describe Domain::Business::Handlers::BusinessCommandHandler do
  let(:event_store) { instance_double(RailsEventStore::Client) }
  let(:handler) { described_class.new(event_store) }

  describe "#call" do
    it "appends BusinessCreated to the business stream with command data" do
      command = Domain::Business::Commands::CreateBusiness.new(
        business_id: "biz-123",
        name: "Acme Corp",
        country: "US",
        owner_user_id: "owner-123"
      )

      expect(event_store).to receive(:append) do |events, stream_name:|
        event = events.to_a.first
        expect(event).to be_a(Domain::Business::Events::BusinessCreated)
        expect(event.business_id).to eq("biz-123")
        expect(event.name).to eq("Acme Corp")
        expect(event.country).to eq("US")
        expect(event.owner_user_id).to eq("owner-123")
        expect(stream_name).to eq("Business-biz-123")
      end

      handler.call(command)
    end
  end
end
