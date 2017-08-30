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
                def listProjectErrors(project_id, options = {})
                    paginate "projects/#{project_id}/errors", options
                end

                # View an Error
                #
                # @return [Sawyer::Resource] Requested Error
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/view-an-error
                def viewError(project_id, id, options = {})
                    get "organizations/#{project_id}/errors/#{id}", options
                end

                # Update an Error
                #
                # @option severity [String] The Error's new severity. One of: info, warning, error
                # @option assigned_collaborator_id [String] THe collaborator to assign to the Error
                # @option issue_url [String] Updates to link to an existing 3rd party issue
                # @option issue_title [String] Updates the issues title
                # @option reopen-rules [Object] Snooze rules for automatically reopening the Error
                # @return [Sawyer::Resource] Updated Error
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/update-an-error
                def updateError(project_id, id, operation, options = {})
                    patch "organizations/#{project_id}/errors/#{id}", options.merge({:operation => operation})
                end

                # Bulk update Errors
                #
                # @option severity [String] The Error's new severity. One of: info, warning, error
                # @option assigned_collaborator_id [String] THe collaborator to assign to the Error
                # @option issue_url [String] Updates to link to an existing 3rd party issue
                # @option issue_title [String] Updates the issues title
                # @option reopen-rules [Object] Snooze rules for automatically reopening the Error
                # @return [Array<Sawyer::Resource>] Updated Errors
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/bulk-update-errors
                def bulkUpdateErrors(project_id, error_ids, operation, options = {})
                    patch "organizations/#{project_id}/errors", options.merge({:operation => operation, :query => {:error_ids => error_ids.join(' ')}})
                end

                # Delete an Error
                #
                # @return 
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/delete-an-error
                def deleteError(id, options = {})
                    delete "errors/#{id}", options
                end

                # Delete all Errors in a Project
                #
                # @return 
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/errors/delete-all-errors-in-a-project
                def deleteAllErrors(project_id, options = {})
                    delete "projects/#{project_id}/errors", options
                end 
            end
        end
    end
end
  