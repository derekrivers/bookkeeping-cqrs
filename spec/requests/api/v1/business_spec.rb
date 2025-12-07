require "rails_helper"
require "securerandom"

RSpec.describe "Business API V1", type: :request do
  let(:event_store) { App.resolve(:event_store) }
  let(:command_bus) { App.resolve(:command_bus) }

  describe "POST /api/v1/business" do
    it "creates a business and persists a BusinessCreated event" do
      business_id = SecureRandom.uuid

      post "/api/v1/business",
           params: {
             business_id: business_id,
             name: "Test Business",
             country: "GB",
             owner_user_id: "owner-1",
             address: {
               line1: "221B Baker Street",
               line2: "Flat B",
               city: "London",
               postcode: "NW1 6XE",
               country_code: "GB"
             }
           }.to_json,
           headers: { "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body)
      expect(body).to include("status" => "ok", "business_id" => business_id)

      stream_events = event_store.read.stream("Business-#{business_id}").to_a
      expect(stream_events.size).to eq(1)

      event = stream_events.first
      expect(event).to be_a(Domain::Business::Events::BusinessCreated)
      expect(event.business_id).to eq(business_id)
      expect(event.name).to eq("Test Business")
      expect(event.country).to eq("GB")
      expect(event.owner_user_id).to eq("owner-1")
      expect(event.main_address).to include(
        line1: "221B Baker Street",
        line2: "Flat B",
        city: "London",
        postcode: "NW1 6XE",
        country_code: "GB"
      )
      expect(event.main_address).to have_key(:id)
    end

    it "returns an error when required params are missing" do
      post "/api/v1/business",
           params: {}.to_json,
           headers: { "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:unprocessable_entity)

      body = JSON.parse(response.body)
      expect(body["error"]).to match(/param is missing or the value is empty or invalid: business_id/)
    end
  end

  describe "GET /api/v1/business/:id" do
    it "returns the business details when the stream exists" do
      business_id = SecureRandom.uuid

      command_bus.call(
        Domain::Business::Commands::CreateBusiness.new(
          business_id: business_id,
          name: "Existing Business",
          country: "US",
          owner_user_id: "owner-2",
          address: {
            line1: "123 Main St",
            line2: "Suite 4",
            city: "Metropolis",
            postcode: "12345",
            country_code: "US"
          }
        )
      )

      get "/api/v1/business/#{business_id}"

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).to include(
        "business_id" => business_id,
        "name" => "Existing Business",
        "country" => "US",
        "owner_user_id" => "owner-2"
      )
      expect(body["main_address"]).to include(
        "line1" => "123 Main St",
        "line2" => "Suite 4",
        "city" => "Metropolis",
        "postcode" => "12345",
        "country_code" => "US"
      )
      expect(body["main_address"]["id"]).to be_a(String)
    end

    it "returns not found when no business stream exists" do
      get "/api/v1/business/non-existent"

      expect(response).to have_http_status(:not_found)

      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Business not found")
    end
  end
end
