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
        def trends_buckets(project_id, buckets_count, error_id=nil, options = {})
          defaults = {:query => {:buckets_count => buckets_count}}
          merged_opts = deep_merge(defaults, options)
          if !error_id.nil?
            get "projects/#{project_id}/errors/#{error_id}/trend", merged_opts
          else
            get "projects/#{project_id}/trend", merged_opts
          end
        end

        # List Trends for an Error in resolution form
        #
        # @option filters [Object] An optional filter object, see http://docs.bugsnagapiv2.apiary.io/#introduction/filtering
        # @return [Array<Sawyer::Resource>] List of Trends as requested
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/errors/trends/list-the-trends-for-an-error-(buckets)
        def trends_resolution(project_id, resolution, error_id=nil, options = {})
          defaults = {:query => {:resolution => resolution}}
          merged_opts = deep_merge(defaults, options)
          if !error_id.nil?
            get "projects/#{project_id}/errors/#{error_id}/trend", merged_opts
          else
            get "projects/#{project_id}/trend", merged_opts
          end
        end
      end
    end
  end
end
