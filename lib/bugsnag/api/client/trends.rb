module Bugsnag
    module Api
        class Client
  
            # Methods for the Pivots API
            #
            # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/trends
            module Trends
                # List Trends for an Error in bucket form
                #
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @return [Array<Sawyer::Resource>] List of Trends as requested
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/trends/list-the-trends-for-an-error-(buckets)
                def list_error_trends_buckets(project_id, error_id, buckets_count, options = {})
                    get "projects/#{project_id}/errors/#{error_id}/trend", options.merge({:query => {:buckets_count => buckets_count}})
                end

                # List Trends for an Error in resolution form
                #
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @return [Array<Sawyer::Resource>] List of Trends as requested
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/trends/list-the-trends-for-an-error-(buckets)
                def list_error_trends_resolution(project_id, error_id, resolution, options = {})
                    get "projects/#{project_id}/errors/#{error_id}/trend", options.merge({:query => {:resolution => resolution}})
                end

                # List Trends for a Project in bucket form
                #
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @return [Array<Sawyer::Resource>] List of Trends as requested
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/trends/list-the-trends-for-a-project-(buckets)
                def list_project_trends_buckets(project_id, buckets_count, options = {})
                    get "projects/#{project_id}/trend", options.merge({:query => {:buckets_count => buckets_count}})
                end

                # List Trends for a Project in resolution form
                #
                # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
                # @return [Array<Sawyer::Resource>] List of Trends as requested
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/trends/list-the-trends-for-a-project-(buckets)
                def list_project_trends_resolution(project_id, resolution, options = {})
                    get "projects/#{project_id}/trend", options.merge({:query => {:resolution => resolution}})
                end
            end
        end
    end
end
  