require "bugsnag/api/response/raise_error"

module Bugsnag
  module Api

    # Configuration storage and defaults for {Client}
    class Configuration

      # Default API endpoint
      DEFAULT_ENDPOINT = "https://api.bugsnag.com"

      # Default User Agent header string
      DEFAULT_USER_AGENT = "Bugsnag API Ruby Gem #{Bugsnag::Api::VERSION}"

      # In Faraday 0.9, Faraday::Builder was renamed to Faraday::RackBuilder
      RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

      # Default Faraday middleware stack
      DEFAULT_MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
        builder.use Bugsnag::Api::Response::RaiseError
        builder.adapter Faraday.default_adapter
      end

      # Configuration options
      attr_accessor :email, :password, :api_token, :endpoint, :user_agent,
                    :proxy, :middleware, :connection_options, :auto_paginate,
                    :per_page

      # Set up configuration defaults
      def initialize
        @endpoint = DEFAULT_ENDPOINT
        @user_agent = DEFAULT_USER_AGENT
        @middleware = DEFAULT_MIDDLEWARE
        @auto_paginate = false
        @connection_options = {
          :headers => {
            :user_agent => DEFAULT_USER_AGENT
          }
        }
      end

      # Load configuration from hash
      def load(options = {})
        options.each {|k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=")}
      end
    end
  end
end
