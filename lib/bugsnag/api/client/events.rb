module Bugsnag
  module Api
    class Client

      # Methods for the Events API
      #
      # @see https://bugsnag.com/docs/api/events
      module Events
        # List a project's events
        #
        # @param project [String] Bugsnag project for which to list events
        # @return [Array<Sawyer::Resource>] List of events
        # @see https://bugsnag.com/docs/api/events#list-a-project-s-events
        # @example
        #   Bugsnag::Api.events("50baed119bf39c1431000004")
        def events(project, options = {})
          paginate "projects/#{project}/events", options
        end
        alias :project_events :events

        # List an error's events
        #
        # @param error [String] Bugsnag error for which to list events
        # @return [Array<Sawyer::Resource>] List of events
        # @see https://bugsnag.com/docs/api/events#list-an-error-s-events
        # @example
        #   Bugsnag::Api.error_events("518031bcd775355c48a1cd4e")
        def error_events(error, options = {})
          paginate "errors/#{error}/events", options
        end

        # Get a single event
        #
        # @param event [String] A Bugsnag event id
        # @return [Sawyer::Resource] The event you requested, if it exists
        # @see https://bugsnag.com/docs/api/events#get-event-details
        # @example
        #   Bugsnag::Api.event("51f5d152f002c6686d013a22")
        def event(event, options = {})
          get "events/#{event}", options
        end

        # Delete an event
        #
        # @param event [String] A Bugsnag event
        # @return [Boolean] `true` if event was deleted
        # @see https://bugsnag.com/docs/api/events#delete-an-event
        def delete_event(event, options = {})
          boolean_from_response :delete, "events/#{event}", options
        end
      end
    end
  end
end
