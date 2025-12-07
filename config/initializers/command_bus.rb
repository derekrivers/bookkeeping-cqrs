Rails.application.config.to_prepare do
  App.register(:event_store, singleton: true) do
    Rails.configuration.event_store
  end

  App.register(:repository, singleton: true) do
    AggregateRoot::Repository.new(App.resolve(:event_store))
  end

  App.register(:business_command_handler, singleton: true) do
    Domain::Business::Handlers::BusinessCommandHandler.new(App.resolve(:repository))
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
end
