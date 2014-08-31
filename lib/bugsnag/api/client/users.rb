module Bugsnag
  module Api
    class Client

      # Methods for the Users API
      #
      # @see https://bugsnag.com/docs/api/users
      module Users
        # List account users
        #
        # @param account [String] Bugsnag account for which to list users
        # @return [Array<Sawyer::Resource>] List of users
        # @see https://bugsnag.com/docs/api/users#list-an-account-s-users
        def users(account=nil, options = {})
          if account.nil? || account.is_a?(Hash)
            options = account || {}

            raise Bugsnag::Api::AccountCredentialsRequired.new(
              "Fetching users without an account id is only possible when "\
              "using an account auth token."
            ) unless token_authenticated?

            paginate "account/users", options
          else
            paginate "accounts/#{account}/users", options
          end
        end
        alias :account_users :users

        # List project users
        #
        # @param account [String] Bugsnag account for which to list users
        # @return [Array<Sawyer::Resource>] List of users
        # @see https://bugsnag.com/docs/api/users#list-an-project-s-users
        def project_users(project, options = {})
          paginate "projects/#{project}/users", options
        end

        # Get a single user
        #
        # @param user [String] Bugsnag user id.
        # @return [Sawyer::Resource]
        # @see https://bugsnag.com/docs/api/users#get-the-authenticated-user
        # @see https://bugsnag.com/docs/api/users#get-user-details
        # @example
        #   Bugsnag::Api.user("515fb9337c1074f6fd000007")
        def user(user=nil, options = {})
          if user.nil? || user.is_a?(Hash)
            options = user || {}

            raise Bugsnag::Api::AccountCredentialsRequired.new(
              "Fetching user without an id is only possible when using "\
              "user auth credentials."
            ) unless basic_authenticated?

            get "user", options
          else
            get "users/#{user}", options
          end
        end

        # Invite a user to an account
        #
        # @param account [String] Bugsnag account to invite user to.
        # @option email [String] The email address of the invitee
        # @option admin [Boolean] Should the invitee be an account admin?
        # @option project_ids [Array<String>] Array of accessible project ids
        # @see https://bugsnag.com/docs/api/users#invite-a-user-to-an-account
        # @example
        #   Bugsnag::Api.invite_user("515fb9337c1074f6fd000009", "james@example.com")
        def invite_user(account, email, options = {})
          post "accounts/#{account}/users", options.merge({:email => email})
        end

        # Update a user's account permissions
        #
        # @param account [String] Bugsnag account to update pemissions for
        # @param user {String} Bugsnag user to update permissions for
        # @see https://bugsnag.com/docs/api/users#update-a-user-s-account-permissions
        # @example
        #   Bugsnag::Api.update_user_permissions("515fb9337c1074f6fd000009", "515fb9337c1074f6fd000007", admin: false)
        def update_user_permissions(account, user, options = {})
          patch "accounts/#{account}/users/#{user}", options
        end

        # Remove a user from an account
        #
        # @param account [String] Bugsnag account to remove user from
        # @param user [String] Bugsnag user to remove
        # @see https://bugsnag.com/docs/api/users#delete-a-user-from-an-account
        # @example
        #   Bugsnag::Api.remove_user("515fb9337c1074f6fd000009", "515fb9337c1074f6fd000007")
        def remove_user(account, user, options = {})
          boolean_from_response :delete, "accounts/#{account}/users/#{user}", options
        end
      end
    end
  end
end
