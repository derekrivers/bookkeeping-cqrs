class Container
  def initialize
    @services = {}
    @singletons = {}
  end

  def register(name, singleton: false, &factory)
    @services[name] = { factory:, singleton: }
  end

  def resolve(name)
    service = @services[name]
    raise "No service registered for #{name}" unless service

    if service[:singleton]
      @singletons[name] ||= service[:factory].call
    else
      service[:factory].call
    end
  end
end

App = Container.new
