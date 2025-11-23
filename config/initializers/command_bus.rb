require Rails.root.join("app/domain")
require Rails.root.join("app/domain/business")
require Rails.root.join("app/domain/business/events/business_created")
require Rails.root.join("app/domain/business/handlers/business_command_handler")
require Rails.root.join("app/domain/business/commands/create_business")
require Rails.root.join("app/domain/business/aggregate")


App.register(:event_store, singleton: true) do
  Rails.configuration.event_store
end

App.register(:business_command_handler, singleton: true) do
  Domain::Business::Handlers::BusinessCommandHandler.new(App.resolve(:event_store))
end

App.register(:command_bus, singleton: true) do
  bus = CommandBus::Bus.new

  bus.use(CommandBus::Middleware::LoggingMiddleware.new)

  bus.register(
    Domain::Business::Commands::CreateBusiness,
    App.resolve(:business_command_handler)
  )

  bus
end
