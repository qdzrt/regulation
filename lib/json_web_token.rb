# froze_literal_string: true

class JsonWebToken
  HMAC_SECRET = Rails.application.credentials.fetch(:secret_key_base)

  def self.encode(payload, expires_in = 24.hours.from_now)
    payload[:exp] = expires_in.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    JWT.decode(token, HMAC_SECRET)
  rescue JWT::ExpiredSignature => e
    nil
  end
end