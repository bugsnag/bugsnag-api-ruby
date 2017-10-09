module Bugsnag
  module Api
    class Client

      # Methods for the Events API
      #
      # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/events
      module Events
        # View an Event
        #
        # @return [Sawyer::Resource] Requested Event
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/events/view-an-event
        def event(project_id, id, options = {})
          get "projects/#{project_id}/events/#{id}", options
        end

        # Delete an Event
        #
        # @return 
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/events/delete-an-event
        def delete_event(project_id, id, options = {})
          boolean_from_response :delete, "projects/#{project_id}/events/#{id}", options
        end

        # List the Events on an Error
        #
        # @option base [String] Only Error Events occuring before this time will be returned
        # @option sort [String] Which field to sort the results by, one of: last_seen, first_seen, users, events
        # @option direction [String] Which direction to sort the results by, one of: asc, desc
        # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
        # @return [Array<Sawyer::Resource>] List of Events for the specified Error
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/events/list-the-events-on-an-error
        def error_events(project_id, error_id, options = {})
          paginate "projects/#{project_id}/errors/#{error_id}/events", options
        end

        # View the latest Event on an Error
        #
        # @return [Sawyer::Resource] Last event reported Event
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/events/view-the-latest-event-on-an-error
        def latest_event(error_id, options = {})
          get "errors/#{error_id}/latest_event", options
        end

        # List the Events on a Project
        #
        # @option base [String] Only Project Events occuring before this time will be returned
        # @option sort [String] Which field to sort the results by, one of: last_seen, first_seen, users, events
        # @option direction [String] Which direction to sort the results by, one of: asc, desc
        # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
        # @return [Array<Sawyer::Resource>] List of Events for the specified Project
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/events/list-the-events-on-a-project
        def project_events(project_id, options = {})
          get "projects/#{project_id}/events", options
        end
      end
    end
  end
end
  