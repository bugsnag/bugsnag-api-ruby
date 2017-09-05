module Bugsnag
    module Api
        class Client
  
            # Methods for the Pivots API
            #
            # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/pivots
            module Pivots
                # List Pivots on an Error
                #
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @option summary_size [Number] The number of elements to include in the list
                # @option pivots [Array] EventField display_ids to identify pivots to return
                # @option per_page [Number] Number of results to be returned per page
                # @return [Array<Sawyer::Resource>] List of Pivots for the Error specified
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/pivots/list-pivots-on-an-error
                def list_error_pivots(project_id, error_id, options = {})
                    paginate "projects/#{project_id}/errors/#{error_id}/pivots", options
                end

                # List values of a Pivot on an Error
                #
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @option sort [String] Sorting method
                # @option base [String] Only Events occuring before this time will be used 
                # @return [Array<Sawyer::Resource>] List of values for the Pivots requested
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/pivots/list-values-of-a-pivot-on-an-error
                def list_error_pivot_values(project_id, error_id, ef_display_id, options = {})
                    paginate "projects/#{project_id}/errors/#{error_id}/pivots/#{ef_display_id}/values", options
                end

                # List Pivots on a Project
                #
                # @option summary_size [Number] The number of elements to include in the list
                # @option pivots [Array] Pivots ids to identify results to return
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @return [Array<Sawyer::Resource>] List of Pivots for the Project specified
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/pivots/list-pivots-on-a-project
                def list_project_pivots(project_id, options = {})
                    get "projects/#{project_id}/pivots", options
                end

                # List values of a Pivot on a Project
                #
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @option sort [String] Sorting method
                # @option base [String] Only Events occuring before this time will be used 
                # @return [Array<Sawyer::Resource>] List of values for the Pivots specified
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/organizations/view-an-organization
                def list_project_pivot_values(project_id, ef_display_id, options = {})
                    paginate "projects/#{project_id}/pivots/#{ef_display_id}/values", options
                end
            end
        end
    end
end
  