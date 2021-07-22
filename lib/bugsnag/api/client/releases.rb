module Bugsnag
  module Api
    class Client
      # Methods for the Releases API
      module Releases
        # List the Releases in a Project
        #
        # @option release_stage [String] Only Releases with this release stage will be returned
        # @option base [String] Only Releases created before this time will be returned
        # @option sort [String] How to sort the results, one of: timestamp, percent_of_sessions
        # @option offset [Number] The pagination offset
        # @option per_page [Number] The number of results to return per page
        # @return [Array<Sawyer::Resource>] List of Events for the specified Error
        # @see https://bugsnagapiv2.docs.apiary.io/#reference/projects/releases/list-releases-on-a-project
        def releases(project_id, options = {})
          get "projects/#{project_id}/releases", options
        end

        # View a single Release
        #
        # @see https://bugsnagapiv2.docs.apiary.io/#reference/projects/releases/view-a-release
        def release(project_id, release_id, options = {})
          get "projects/#{project_id}/releases/#{release_id}", options
        end

        # List the Releases in a Release Group
        #
        # @option per_page [Number] The number of results to return per page
        # @option page_token [String] Value from the next relation in the Link response header to obtain the next page of results
        # @return [Array<Sawyer::Resource>] List of Releases for the specified Release Group
        # @see https://bugsnagapiv2.docs.apiary.io/#reference/projects/releases/list-releases-on-a-release-group
        def releases_in_group(release_group_id, options = {})
          get "release_groups/#{release_group_id}/releases", options
        end
      end
    end
  end
end
