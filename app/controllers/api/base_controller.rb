module Api
  class BaseController < ApplicationController
    private

    def command_bus
      App.resolve(:command_bus)
    end

    def event_store
      App.resolve(:event_store)
    end

    # Optional shared error rendering
    def render_error(message, status: :unprocessable_entity)
      render json: { error: message }, status: status
    end

    # Optional: strong typed parameter helper
    def require_params(*keys)
      keys.each_with_object({}) do |key, hash|
        hash[key] = params.require(key)
      end
    end

    rescue_from Domain::Business::Errors::BusinessAlreadyExists do |e|
      render_error(e.message, 409)
    end
  end
end
