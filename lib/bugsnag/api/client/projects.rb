module Bugsnag
  module Api
    class Client

      # Methods for the Projects API
      #
      # @see https://bugsnag.com/docs/api/projects
      module Projects
        # List account projects
        #
        # @param account [String] Bugsnag account for which to list projects
        # @return [Array<Sawyer::Resource>] List of projects
        # @see https://bugsnag.com/docs/api/projects#list-an-account-s-projects
        # @example
        #   Bugsnag::Api.projects("515fb9337c1074f6fd000009")
        def projects(account=nil, options = {})
          if account.nil? || account.is_a?(Hash)
            options = account || {}

            raise Bugsnag::Api::AccountCredentialsRequired.new(
              "Fetching projects without an account id is only possible when "\
              "using an account auth token."
            ) unless token_authenticated?

            paginate "account/projects", options
          else
            paginate "accounts/#{account}/projects", options
          end
        end
        alias :account_projects :projects

        # List user projects
        #
        # @param account [String] Bugsnag user for which to list projects
        # @return [Array<Sawyer::Resource>] List of projects
        # @see https://bugsnag.com/docs/api/projects#list-a-user-s-projects
        # @example
        #   Bugsnag::Api.user_projects("515fb9337c1074f6fd000007")
        def user_projects(user, options = {})
          paginate "users/#{user}/projects", options
        end

        # Get a single project
        #
        # @param project [String] A Bugsnag project
        # @return [Sawyer::Resource] The project you requested, if it exists
        # @see https://bugsnag.com/docs/api/projects#get-project-details
        # @example
        #   Bugsnag::Api.project("50baed119bf39c1431000004")
        def project(project, options = {})
          get "projects/#{project}", options
        end

        # Create a project
        #
        # @param account [String] The Bugsnag account to create project on
        # @option name [String] The project's name
        # @option type [String] The type of the project
        # @see https://bugsnag.com/docs/api/projects#create-a-project
        # @example
        #   Bugsnag::Api.create_project("515fb9337c1074f6fd000009", name: "Website")
        def create_project(account=nil, options = {})
          if account.nil? || account.is_a?(Hash)
            options = account || {}

            raise Bugsnag::Api::AccountCredentialsRequired.new(
              "Fetching projects without an account id is only possible when "\
              "using an account auth token."
            ) unless token_authenticated?

            post "account/projects", options
          else
            post "accounts/#{account}/projects", options
          end
        end

        # Update a project
        #
        # @param project [String] A Bugsnag project
        # @return [Sawyer::Resource] The updated project
        # @see https://bugsnag.com/docs/api/projects#update-a-project
        # @example
        #   Bugsnag::Api.update_project("50baed119bf39c1431000004", name: "Dashboard")
        def update_project(project, options = {})
          patch "projects/#{project}", options
        end

        # Delete a project
        #
        # @param project [String] A Bugsnag project
        # @return [Boolean] `true` if project was deleted
        # @see https://bugsnag.com/docs/api/projects#delete-a-project
        def delete_project(project, options = {})
          boolean_from_response :delete, "projects/#{project}", options
        end
      end
    end
  end
end
