module APIError
  extend ActiveSupport::Concern

  included do
    # error_formatter :json, ->(message, backtrace, options, env){
    #   "error: #{message} from #{backtrace}"
    # }

    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_response(message: e.message, status: 406)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error_response(message: e.message, status: 400)
    end

    rescue_from ArgumentError do |e|
      error_response(message: e.message, status: 400)
    end

    rescue_from JWT::ExpiredSignature do |e|
      error_response(message: "The 'access_token' is invalid or has been expired !", status: 401)
    end

    rescue_from JWT::DecodeError do |e|
      error_response(message: e.message, status: 401)
    end

    rescue_from :all do |e|
      Rails.logger.error "\n#{e.class.name} (#{e.message}):"
      e.backtrace.each { |line| Rails.logger.error line }
      error_response(message: e.message, status: 500)
    end
  end
end