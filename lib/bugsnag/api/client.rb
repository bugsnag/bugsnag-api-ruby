require "sawyer"

require "bugsnag/api/client/organizations"
require "bugsnag/api/client/collaborators"
require "bugsnag/api/client/projects"
require "bugsnag/api/client/eventfields"
require "bugsnag/api/client/currentuser"
require "bugsnag/api/client/errors"
require "bugsnag/api/client/events"
require "bugsnag/api/client/pivots"
require "bugsnag/api/client/trends"
require "bugsnag/api/client/comments"

module Bugsnag
  module Api

    # Client for the Bugsnag API
    #
    # @see http://docs.bugsnagapiv2.apiary.io/
    class Client
      include Bugsnag::Api::Client::Organizations
      include Bugsnag::Api::Client::Collaborators
      include Bugsnag::Api::Client::Projects
      include Bugsnag::Api::Client::EventFields
      include Bugsnag::Api::Client::CurrentUser
      include Bugsnag::Api::Client::Errors
      include Bugsnag::Api::Client::Events
      include Bugsnag::Api::Client::Pivots
      include Bugsnag::Api::Client::Trends
      include Bugsnag::Api::Client::Comments

      # Header keys that can be passed in options hash to {#get},{#head}
      CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

      def initialize(options = {}, &block)
        configuration.load(options)
        yield(configuration) if block_given?
      end

      # Set configuration options using a block
      def configure
        yield(configuration) if block_given?
        reset_agent
      end

      # Get client's configuration options
      #
      # @return [Bugsnag::Api::Configuration] configuration wrapper
      def configuration
        @configuration ||= Configuration.new
      end

      # Make a HTTP GET request
      #
      # @param url [String] The path, relative to {#endpoint}
      # @param options [Hash] Query and header params for request
      # @return [Sawyer::Resource]
      def get(url, options = {})
        request :get, url, parse_query_and_convenience_headers(options)
      end

      # Make a HTTP POST request
      #
      # @param url [String] The path, relative to {#endpoint}
      # @param options [Hash] Body and header params for request
      # @return [Sawyer::Resource]
      def post(url, options = {})
        request :post, url, options
      end

      # Make a HTTP PATCH request
      #
      # @param url [String] The path, relative to {#endpoint}
      # @param options [Hash] Body and header params for request
      # @return [Sawyer::Resource]
      def patch(url, options = {})
        request :patch, url, options
      end

      # Make a HTTP DELETE request
      #
      # @param url [String] The path, relative to {#endpoint}
      # @param options [Hash] Query and header params for request
      # @return [Sawyer::Resource]
      def delete(url, options = {})
        request :delete, url, options
      end

      # Make one or more HTTP GET requests, optionally fetching
      # the next page of results from URL in Link response header based
      # on value in {#auto_paginate}.
      #
      # @param url [String] The path, relative to {#endpoint}
      # @param options [Hash] Query and header params for request
      # @param block [Block] Block to perform the data concatination of the
      #   multiple requests. The block is called with two parameters, the first
      #   contains the contents of the requests so far and the second parameter
      #   contains the latest response.
      # @return [Sawyer::Resource]
      def paginate(url, options = {}, &block)
        opts = parse_query_and_convenience_headers(options.dup)
        if configuration.auto_paginate || configuration.per_page
          opts[:query][:per_page] ||=  configuration.per_page || (configuration.auto_paginate ? 100 : nil)
        end

        data = request(:get, url, opts)

        if configuration.auto_paginate
          while @last_response.rels[:next]
            @last_response = @last_response.rels[:next].get
            if block_given?
              yield(data, @last_response)
            else
              data.concat(@last_response.data) if @last_response.data.is_a?(Array)
            end
          end
        end

        data
      end

      # Response for last HTTP request
      #
      # @return [Sawyer::Response]
      def last_response
        @last_response if defined? @last_response
      end

      # Indicates if the client was supplied Basic Auth
      # username and password
      #
      # @see https://bugsnag.com/docs/api#user-authentication
      # @return [Boolean]
      def basic_authenticated?
        !!(configuration.email && configuration.password)
      end

      # Indicates if the client was supplied an auth token
      #
      # @see https://bugsnag.com/docs/api#account-authentication
      # @return [Boolean]
      def token_authenticated?
        !!configuration.auth_token
      end

      # Merges hashes together cleanly, favouring RHS values
      #
      # @return [Hash]
      def deep_merge(l_hash, r_hash)
        l_hash.merge(r_hash) do |key, l_val, r_val|
          if l_val.is_a?(Hash) && r_val.is_a?(Hash)
            deep_merge(l_val, r_val)
          else
            r_val
          end
        end
      end

      private
      def agent
        @agent ||= Sawyer::Agent.new(configuration.endpoint, sawyer_options) do |http|
          http.headers[:content_type] = "application/json"
          http.headers[:'X-Version'] = "2"
          http.headers[:user_agent] = configuration.user_agent

          if basic_authenticated?
            http.basic_auth configuration.email, configuration.password
          elsif token_authenticated?
            http.authorization "token", configuration.auth_token
          end
        end
      end

      def reset_agent
        @agent = nil
      end

      def request(method, path, data, options = {})
        if data.is_a?(Hash)
          options[:query]   = data.delete(:query) || {}
          options[:headers] = data.delete(:headers) || {}
          if accept = data.delete(:accept)
            options[:headers][:accept] = accept
          end
        end

        @last_response = response = agent.call(method, URI.escape(path.to_s), data, options)
        response.data
      end

      def boolean_from_response(method, path, options = {})
        request(method, path, options)
        @last_response.status == 204
      rescue Bugsnag::Api::NotFound
        false
      end

      def sawyer_options
        opts = {
          :links_parser => Sawyer::LinkParsers::Simple.new
        }
        conn_opts = configuration.connection_options
        conn_opts[:builder] = configuration.middleware if configuration.middleware
        conn_opts[:proxy] = configuration.proxy if configuration.proxy
        opts[:faraday] = Faraday.new(conn_opts)

        opts
      end

      def parse_query_and_convenience_headers(options)
        headers = options.fetch(:headers, {})
        CONVENIENCE_HEADERS.each do |h|
          if header = options.delete(h)
            headers[h] = header
          end
        end
        query = options.delete(:query)
        opts = {:query => options}
        opts[:query].merge!(query) if query && query.is_a?(Hash)
        opts[:headers] = headers unless headers.empty?

        opts
      end
    end
  end
end
