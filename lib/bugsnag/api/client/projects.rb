module Bugsnag
    module Api
        class Client
  
            # Methods for the Projects API
            #
            # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects
            module Projects
                # Create a Project in an Organization
                #
                # @return [Sawyer::Resource] New Project
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/projects/create-a-project-in-an-organization
                def create_project(org_id, name, type, options = {})
                    post "organizations/#{org_id}/projects", options.merge({:name => name, :type => type})
                end

                # View a Project
                #
                # @return [Sawyer::Resource] Requested Project
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/projects/view-a-project
                def view_project(id, options = {})
                    get "projects/#{id}", options
                end

                # Update a Project
                #
                # @option name [String] A name for the project
                # @option global_grouping [Array<String>] A list of error classes, which will be grouped by class
                # @option location_grouping [Array<String>] A list of error classes, which will be grouped by context
                # @option discarded_app_versions [Array<String>] A list of app versions whose events will be ignored
                # @option discarded_errors [Array<String>] A list of error classes that will be ignored
                # @option url_whitelist [Array<String>] If configured only errors from whitelisted URLs will be processed
                # @option ignore_old_browsers [Boolean] Set to ignore events from old web browsers
                # @option ignored_browser_versions [Object] A mapping of browser name to ignored versions
                # @option resolve_on_deploy [Boolean] Set all errors to resolved once a new deployment has been notified
                # @option collaborator_ids [Array<String>] Update the collaborators in the project to only these ids
                # @return [Sawyer::Resource] Updated Project
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/projects/update-a-project
                def update_project(id, options = {})
                    patch "projects/#{id}", options
                end

                # Regenerate a Project's notifier API key
                #
                # @return 
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/projects/regenerate-a-project's-notifier-api-key
                def regenerate_api_key(id, options = {})
                    delete "projects/#{id}/api_key", options
                end

                # Delete a Project
                #
                # @return 
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/organizations/delete-an-organization
                def delete_project(id, options = {})
                    boolean_from_response :delete, "projects/#{id}", options
                end
            end
        end
    end
end
  