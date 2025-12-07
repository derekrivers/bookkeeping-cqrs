require "securerandom"

event_store = App.resolve(:event_store)
command_bus = App.resolve(:command_bus)

default_business_id = ENV.fetch("SEED_BUSINESS_ID", "00000000-0000-0000-0000-000000000001")
stream = "Business-#{default_business_id}"

if event_store.read.stream(stream).limit(1).to_a.empty?
  command_bus.call(
    Domain::Business::Commands::CreateBusiness.new(
      business_id: default_business_id,
      name: "Acme Corp",
      country: "US",
      owner_user_id: ENV.fetch("SEED_OWNER_USER_ID", "seed-owner"),
      address: {
        line1: "21 Browning St",
        line2: "Easington Colliery",
        city: "Durham",
        postcode: "SR83RY",
        country_code: "GB"
      }
    )
  )
  puts "Seeded business #{default_business_id}"
else
  puts "Business #{default_business_id} already seeded"
end
