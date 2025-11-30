require "spec_helper"

RSpec.describe Domain::Business::Commands::CreateBusiness do
  describe "#initialize" do
    it "stores the provided attributes" do
      command = described_class.new(
        business_id: "biz-123",
        name: "Acme Corp",
        country: "US",
        owner_user_id: "owner-123"
      )

      expect(command.business_id).to eq("biz-123")
      expect(command.name).to eq("Acme Corp")
      expect(command.country).to eq("US")
      expect(command.owner_user_id).to eq("owner-123")
    end
  end
end
