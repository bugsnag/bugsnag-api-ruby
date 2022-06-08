require "bugsnag/api/client"
require "bugsnag/api/configuration"
require "bugsnag/api/error"
require "bugsnag/api/version"

module Bugsnag

  # Static access to a Bugsnag API Client
  module Api
    class << self
      # Set configuration options using a block
      def configure(&block)
        client.configure(&block) if block_given?
      end

      # Get the static client's configuration options
      #
      # @return [Bugsnag::Api::Configuration] configuration wrapper
      def configuration
        client.configuration
      end

      # Get the static API client. Note that using the static API
      # client may not work as expected in a multithreaded environment
      # (e.g. when using the {#paginate} or {#last_response} instance
      # methods)
      #
      # @return [Bugsnag::Api::Client] API client
      def client
        @client ||= Bugsnag::Api::Client.new
      end

      # Reset the static API client
      #
      # @return [Bugsnag::Api::Client] API client
      def reset!
        @client = nil
      end


      private
      def method_missing(method_name, *args, &block)
        return super unless client.respond_to?(method_name)
        client.send(method_name, *args, &block)
      end
    end
  end
end
