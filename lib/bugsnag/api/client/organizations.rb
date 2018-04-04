module Bugsnag
  module Api
    class Client

      # Methods for the Organizations API
      #
      # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations
      module Organizations
        # Create an Organization
        #
        # @return [Sawyer::Resource] New Organization
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/organizations/create-an-organization
        def create_organization(name, options = {})
          post "organizations", options.merge({:name => name})
        end

        # View an Organization
        #
        # @return [Sawyer::Resource] Requested Organization
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/organizations/view-an-organization
        def organization(id, options = {})
          get "organizations/#{id}", options
        end

        # Update an Organization
        #
        # @option invoice_address [String] Additional information to print on your invoice
        # @option billing_emails [Array<String>] List of billing emails
        # @return [Sawyer::Resource] Updated Organization
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/organizations/update-an-organization
        def update_organization(id, name, auto_upgrade, options = {})
          patch "organizations/#{id}", options.merge({:name => name, :auto_upgrade => auto_upgrade})
        end

        # Delete an Organization
        #
        # @return
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/organizations/delete-an-organization
        def delete_organization(id, options = {})
          boolean_from_response :delete, "organizations/#{id}", options
        end
      end
    end
  end
end
