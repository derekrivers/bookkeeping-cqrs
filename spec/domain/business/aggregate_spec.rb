require "spec_helper"

RSpec.describe Domain::Business::Aggregate do
  let(:aggregate) { described_class.new("biz-123") }

  describe "#create" do
    it "records a BusinessCreated event with provided attributes" do
      aggregate.create(
        name: "Acme Corp",
        country: "US",
        owner_user_id: "owner-123"
      )

      events = aggregate.unpublished_events.to_a
      expect(events.size).to eq(1)

      event = events.first
      expect(event).to be_a(Domain::Business::Events::BusinessCreated)
      expect(event.business_id).to eq("biz-123")
      expect(event.name).to eq("Acme Corp")
      expect(event.country).to eq("US")
      expect(event.owner_user_id).to eq("owner-123")
    end

    it "raises when called more than once" do
      aggregate.create(
        name: "Acme Corp",
        country: "US",
        owner_user_id: "owner-123"
      )

      expect do
        aggregate.create(
          name: "Another Corp",
          country: "GB",
          owner_user_id: "owner-456"
        )
      end.to raise_error("Already created")
    end
  end
end
