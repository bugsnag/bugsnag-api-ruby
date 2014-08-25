require "bugsnag/api/client"
require "bugsnag/api/configuration"
require "bugsnag/api/error"
require "bugsnag/api/version"

module Bugsnag
  module Api
    class << self
      def configure
        yield(configuration) if block_given?
      end

      def configuration
        @configuration ||= Bugsnag::Api::Configuration.new
      end

      def client
        @client ||= Bugsnag::Api::Client.new(configuration)
      end


      private
      def method_missing(method_name, *args, &block)
        return super unless client.respond_to?(method_name)
        client.send(method_name, *args, &block)
      end
    end
  end
end
