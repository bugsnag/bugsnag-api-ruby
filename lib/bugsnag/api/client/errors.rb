module Bugsnag
  module Api
    class Client

      # Methods for the Errors API
      #
      # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors
      module Errors
        # List the Errors on a Project
        #
        # @option base [String] Only Error Events occuring before this time will be returned
        # @option sort [String] Which field to sort by, one of: last_seen, first_seen, users, events, unsorted
        # @option direction [String] Which direction to sort the result by, one of: asc, desc
        # @option filters [Filters] An optional filters object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
        # @return [Array<Sawyer::Resource>] List of Project Errors
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/list-the-errors-on-a-project
        def errors(project_id, id=nil, options = {})
          paginate "projects/#{project_id}/errors", options
        end

        # View an Error
        #
        # @return [Sawyer::Resource] Requested Error
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/view-an-error
        def error(project_id, id, options = {})
          get "projects/#{project_id}/errors/#{id}", options
        end

        # Update an Error
        #
        # @argument ids [(Array<String>/String)] An Id, or array of Ids to update
        #
        # @option severity [String] The Error's new severity. One of: info, warning, error
        # @option assigned_collaborator_id [String] THe collaborator to assign to the Error
        # @option issue_url [String] Updates to link to an existing 3rd party issue
        # @option issue_title [String] Updates the issues title
        # @option reopen_rules [Object] Snooze rules for automatically reopening the Error
        # @return [Sawyer::Resource] Updated Error
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/update-an-error
        def update_errors(project_id, ids, operation, options = {})
          case ids
          when String
            patch "projects/#{project_id}/errors/#{ids}", options.merge({:operation => operation})
          when Array
            patch "projects/#{project_id}/errors", options.merge({:operation => operation, :query => {:error_ids => ids.join(' ')}})
          else
            raise ArgumentError, "ids must be a String or an Array"
          end
        end

        # Delete an Error
        #
        # @argument error_id [String] ID of error to delete (conflicts with project_id)
        # @argument project_id [String] Id of project to delete all errors from (conflicts with error_id)
        #
        # @return 
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/delete-an-error
        def delete_errors(project_id, error_id=nil, options = {})
          if !error_id.nil?
            boolean_from_response :delete, "projects/#{project_id}/errors/#{error_id}", options
          else
            boolean_from_response :delete, "projects/#{project_id}/errors", options
          end
        end
      end
    end
  end
end
  