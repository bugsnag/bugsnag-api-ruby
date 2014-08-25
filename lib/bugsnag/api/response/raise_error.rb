require "faraday"
require "bugsnag/api/error"

module Bugsnag
  module Api
    # Faraday response middleware
    module Response

      # This class raises an Bugsnag-flavored exception based
      # HTTP status codes returned by the API
      class RaiseError < Faraday::Response::Middleware

        private
        def on_complete(response)
          if error = Bugsnag::Api::Error.from_response(response)
            raise error
          end
        end
      end
    end
  end
end
