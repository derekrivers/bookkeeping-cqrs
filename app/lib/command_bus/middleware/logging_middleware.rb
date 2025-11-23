module CommandBus
  module Middleware
    class LoggingMiddleware
      def call(command, next_middleware)
        puts "[COMMAND] #{command.class}"

        next_middleware.call(command)
      end
    end
  end
end
