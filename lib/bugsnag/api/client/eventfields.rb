module Bugsnag
    module Api
        class Client
  
            # Methods for the Project Event Fields API
            #
            # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/event-fields
            module EventFields
                # List the Event Fields for a Project
                #
                # @option per_page []Number] Number of results required per page
                # @return [Array<Sawyer::Resource>] List of event fields
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/event-fields/list-the-event-fields-for-a-project
                def list_event_fields(project_id, options = {})
                    paginate "projects/#{project_id}/event_fields", options
                end

                # Create a custom Event Field
                #
                # @option reindex [Boolean] Whether to reindex historical events
                # @option pivot_options [Object] Configuration for how this field will appear in pivots
                # @return [Sawyer::Resource] New Event Field
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/event-fields/create-a-custom-event-field
                def create_event_field(project_id, display_id, path, filter_options, options = {})
                    post "projects/#{project_id}/event_fields", options.merge({:display_id => display_id, :path => path, :filter_options => filter_options})
                end

                # Update a custom Event Field
                #
                # @option reindex [Boolean] Whether to reindex historical events
                # @option filter_options [Object] Configuration for how the field will appear in the Filter Bar
                # @option pivot_options [Object] Configuration for how this field will appear in pivots
                # @return [Sawyer::Resource] Updated Event Field
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/event-fields/update-a-custom-event-field
                def update_event_field(project_id, display_id, path, options = {})
                    patch "projects/#{id}/event_fields/#{display_id}", options.merge({:display_id => display_id, :path => path})
                end

                # Delete a custom Event Field
                #
                # @return 
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/projects/event-fields/delete-a-custom-event-field
                def delete_event_field(project_id, display_id, options = {})
                    boolean_from_resposne :delete, "project/#{project_id}/event_fields/#{display_id}", options
                end
            end
        end
    end
end
  