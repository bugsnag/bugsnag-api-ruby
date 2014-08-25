module Bugsnag
  module Api
    class Client

      # Methods for the Accounts API
      #
      # @see https://bugsnag.com/docs/api/accounts
      module Accounts
        # List your accounts
        #
        # @return [Array<Sawyer::Resource>] List of users
        # @see https://bugsnag.com/docs/api/accounts#list-your-accounts
        # @example
        #   Bugsnag::Api.accounts
        def accounts(options = {})
          paginate "accounts", options
        end

        # Get a single account
        #
        # @param account [String] Bugsnag account id
        # @return [Sawyer::Resource]
        # @see https://bugsnag.com/docs/api/accounts#get-the-authenticated-account
        # @see https://bugsnag.com/docs/api/accounts#get-account-details
        # @example
        #   Bugsnag::Api.account("515fb9337c1074f6fd000009")
        def account(account=nil, options = {})
          if account.nil?
            get "account", options
          else
            get "accounts/#{account}", options
          end
        end
      end
    end
  end
end
