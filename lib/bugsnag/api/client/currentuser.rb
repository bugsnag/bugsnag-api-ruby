module Bugsnag
  module Api
    class Client

      # Methods for theCurrent User API
      #
      # @see http://docs.bugsnagapiv2.apiary.io/#reference/current-user
      module CurrentUser
        # List the Current User's Organizations
        #
        # @option admin [Boolean] If only Organizations the user is an admin of should be returned
        # @option per_page [Number] Number of results to return per-page
        # @return [Array<Sawyer::Resource>] List of Organizations
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/current-user/organizations/list-the-current-user's-organizations
        def organizations(options = {})
          paginate "user/organizations", options
        end

        # List the Current User's Projects
        #
        # @option sort [String] Which field to sort the results by, one of: created_at
        # @option direction [String] Which direction to sort the results by, on of: asc, desc
        # @option per_page [Number] Number of results to return per-page
        # @return [Array<Sawyer::Resource>] List of Projects
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/current-user/organizations/list-the-current-user's-projects
        def projects(org_id, options = {})
          paginate "organizations/#{org_id}/projects", options
        end
      end
    end
  end
end
