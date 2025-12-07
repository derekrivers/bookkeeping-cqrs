module Api
  module V1
    class BusinessController < Api::BaseController
      def show
        business_id = params.require(:id)

        event = event_store
          .read
          .stream(business_stream(business_id))
          .limit(1)
          .backward
          .first

        if event.nil?
          render_error("Business not found", status: :not_found)
        else
          render json: {
            business_id: event.business_id,
            name: event.name,
            country: event.country,
            owner_user_id: event.owner_user_id,
            main_address: event.main_address
          }, status: :ok
        end
      rescue ActionController::ParameterMissing => e
        render_error(e.message)
      end

      def create
        attrs = require_params(:business_id, :name, :country, :owner_user_id)
        address = params.require(:address).permit(:line1, :line2, :city, :postcode, :country_code).to_h.symbolize_keys
        business_params = attrs.merge(address: address)

        command = Domain::Business::Commands::CreateBusiness.new(**business_params)

        command_bus.call(command)

        render json: { status: "ok", business_id: command.business_id }, status: :created
      rescue ActionController::ParameterMissing => e
        render_error(e.message)
      end

      private

      def business_stream(business_id)
        "Business-#{business_id}"
      end
    end
  end
end
