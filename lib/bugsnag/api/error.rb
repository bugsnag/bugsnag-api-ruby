module Bugsnag
  module Api
    # Custom error class for rescuing from all Bugsnag API errors
    class Error < StandardError

      # Returns the appropriate Bugnsag::Api::Error subclass based
      # on status and response message
      #
      # @param [Hash] response HTTP response
      # @return [Octokit::Error]
      def self.from_response(response)
        status  = response[:status].to_i
        body    = response[:body].to_s
        headers = response[:response_headers]

        if klass =  case status
                    when 400      then Bugsnag::Api::BadRequest
                    when 401      then Bugsnag::Api::Unauthorized
                    when 403      then Bugsnag::Api::Forbidden
                    when 404      then Bugsnag::Api::NotFound
                    when 405      then Bugsnag::Api::MethodNotAllowed
                    when 406      then Bugsnag::Api::NotAcceptable
                    when 409      then Bugsnag::Api::Conflict
                    when 415      then Bugsnag::Api::UnsupportedMediaType
                    when 422      then Bugsnag::Api::UnprocessableEntity
                    when 400..499 then Bugsnag::Api::ClientError
                    when 500      then Bugsnag::Api::InternalServerError
                    when 501      then Bugsnag::Api::NotImplemented
                    when 502      then Bugsnag::Api::BadGateway
                    when 503      then Bugsnag::Api::ServiceUnavailable
                    when 500..599 then Bugsnag::Api::ServerError
                    end
          klass.new(response)
        end
      end

      def initialize(response=nil)
        @response = response
        super(response_error)
      end

      private

      def data
        @data ||=
          if (body = @response[:body]) && !body.empty?
            if body.is_a?(String) &&
              @response[:response_headers] &&
              @response[:response_headers][:content_type] =~ /json/

              Sawyer::Agent.serializer.decode(body)
            else
              body
            end
          else
            nil
          end
      end

      def response_error
        "Error: #{data[:error]}" if data.is_a?(Hash) && data[:error]
      end
    end

    # Raised on errors in the 400-499 range
    class ClientError < Error; end

    # Raised when Bugsnag returns a 400 HTTP status code
    class BadRequest < ClientError; end

    # Raised when Bugsnag returns a 401 HTTP status code
    class Unauthorized < ClientError; end

    # Raised when Bugsnag returns a 403 HTTP status code
    class Forbidden < ClientError; end

    # Raised when Bugsnag returns a 404 HTTP status code
    class NotFound < ClientError; end

    # Raised when Bugsnag returns a 405 HTTP status code
    class MethodNotAllowed < ClientError; end

    # Raised when Bugsnag returns a 406 HTTP status code
    class NotAcceptable < ClientError; end

    # Raised when Bugsnag returns a 409 HTTP status code
    class Conflict < ClientError; end

    # Raised when Bugsnag returns a 414 HTTP status code
    class UnsupportedMediaType < ClientError; end

    # Raised when Bugsnag returns a 422 HTTP status code
    class UnprocessableEntity < ClientError; end

    # Raised on errors in the 500-599 range
    class ServerError < Error; end

    # Raised when Bugsnag returns a 500 HTTP status code
    class InternalServerError < ServerError; end

    # Raised when Bugsnag returns a 501 HTTP status code
    class NotImplemented < ServerError; end

    # Raised when Bugsnag returns a 502 HTTP status code
    class BadGateway < ServerError; end

    # Raised when Bugsnag returns a 503 HTTP status code
    class ServiceUnavailable < ServerError; end

    # Raised when client fails to provide valid Content-Type
    class MissingContentType < ArgumentError; end

    # Raised when a method requires account-level credentials
    # but none were provided
    class AccountCredentialsRequired < StandardError; end

    # Raised when a method requires user-level credentials
    # but none were provided
    class UserCredentialsRequired < StandardError; end
  end
end
