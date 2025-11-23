module CommandBus
  class Bus
    def initialize
      @handlers = {}
      @middleware = []
    end

    def register(command_class, handler)
      @handlers[command_class] = handler
    end

    def use(middleware)
      @middleware << middleware
    end

    def call(command)
      chain = build_chain(@middleware.dup)
      chain.call(command)
    end

    private

    def build_chain(middleware)
      handler = ->(cmd) { @handlers[cmd.class].call(cmd) }

      middleware.reverse.inject(handler) do |next_mw, mw|
        ->(cmd) { mw.call(cmd, next_mw) }
      end
    end
  end
end
