module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(last_response.body, symbolize_names: true)
    end
  end

  module AuthHelpers
    def auth_headers(user_id)
      JsonWebToken.encode({user_id: user_id})
    end

    def expired_auth_headers(user_id)
      JsonWebToken.encode({user_id: user_id}, Time.zone.now.to_i - 10)
    end

    def valid_headers
      {
        'HTTP_AUTHORIZATION' => "Bearer #{auth_headers(user.id)}",
        'Content-Type' => 'application/json'
      }
    end

    def invalid_headers
      {
        'HTTP_AUTHORIZATION' => nil,
        'Content-Type' => 'application/json'
      }
    end
  end
end