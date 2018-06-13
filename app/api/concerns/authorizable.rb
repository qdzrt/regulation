module Authorizable
  extend ActiveSupport::Concern

  included do
    helpers do
      def authorize
        header = headers['Authorization']
        if header
          token = header.sub(/\ABearer?\s+/, '')
          payload, _ = JsonWebToken.decode(token)
          if payload
            @current_user = User.find(payload['user_id'])
          end
        end
      end

      def current_user
        @current_user ||= authorize
      end

      def authenticate!
        error!('Unauthorized', 401) unless current_user
      end
    end
  end
end