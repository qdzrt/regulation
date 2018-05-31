module Authorizable
  extend ActiveSupport::Concern

  included do
    helpers do
      def authorization(payload, expires_in = 24.hours)
        payload[:exp] = Time.zone.now.to_i + expires_in
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
      end

      def authorize
        header = headers['Authorization']
        if header
          token = header.sub(/\ABearer:?\s+/, '')
          begin
            payload, _ = JWT.decode(token, Rails.application.secrets.secret_key_base)
            if payload
              @current_user = User.find(payload['user']['id'])
            end
          rescue JWT::ExpiredSignature
            nil
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