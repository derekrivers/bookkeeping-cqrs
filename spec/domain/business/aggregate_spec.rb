require "spec_helper"

RSpec.describe Domain::Business::Aggregate do
  let(:aggregate) { described_class.new("biz-123") }
  let(:main_address) do
    {
      id: "addr-123",
      line1: "123 Main St",
      line2: "Suite 4",
      city: "Metropolis",
      postcode: "12345",
      country_code: "US"
    }
  end

  describe "#create" do
    it "records a BusinessCreated event with provided attributes" do
      aggregate.create(
        name: "Acme Corp",
        country: "US",
        owner_user_id: "owner-123",
        main_address: main_address
      )

      events = aggregate.unpublished_events.to_a
      expect(events.size).to eq(1)

      event = events.first
      expect(event).to be_a(Domain::Business::Events::BusinessCreated)
      expect(event.business_id).to eq("biz-123")
      expect(event.name).to eq("Acme Corp")
      expect(event.country).to eq("US")
      expect(event.owner_user_id).to eq("owner-123")
      expect(event.main_address).to eq(main_address)

      addresses = aggregate.instance_variable_get(:@addresses)
      stored_address = addresses[main_address[:id]]
      expect(stored_address.line1).to eq("123 Main St")
      expect(aggregate.instance_variable_get(:@main_address_id)).to eq(main_address[:id])
    end

    it "raises when called more than once" do
      aggregate.create(
        name: "Acme Corp",
        country: "US",
        owner_user_id: "owner-123",
        main_address: main_address
      )

      expect do
        aggregate.create(
          name: "Another Corp",
          country: "GB",
          owner_user_id: "owner-456",
          main_address: main_address.merge(id: "addr-999")
        )
      end.to raise_error(Domain::Business::Errors::BusinessAlreadyExists)
    end
  end
end
