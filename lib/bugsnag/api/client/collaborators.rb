module Bugsnag
  module Api
    class Client

      # Methods for the Organizations Collaborators API
      #
      # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators
      module Collaborators
        # View a Collaborator
        #
        # @return [Sawyer::Resource] Collaborator
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/view-a-collaborator
        def collaborator(org_id, collaborator_id, options = {})
          get "organizations/#{org_id}/collaborators/#{collaborator_id}", options
        end

        # List Collaborators
        #
        # @argument project_id [String] ID of project to get collaborators from (conflicts with org_id)
        # @argument org_id [String] ID of organization to get collaborators from (conflicts with project_id)
        #
        # @option per_page [Number] Amount of results per-page             
        # @return [Array<Sawyer::Resource>] List of Collaborators
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/list-collaborators
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/list-collaborators-on-a-project
        def collaborators(org_id = nil, project_id = nil, options = {})
          if !org_id.nil?
            paginate "organizations/#{org_id}/collaborators", options
          elsif !project_id.nil?
            paginate "projects/#{project_id}/collaborators", options
          else
            raise ArgumentError, "Must supply either an org_id or a project_id"
          end
        end

        # Invite Collaborators
        #
        # @argument emails [(Array<String>/String)] A (list of emails/singular email) to invite
        #
        # @option project_ids [Array<String>] The ids in the organization the user(s) should have access to
        # @option admin [Boolean] Whether to give admin permissions. Admins have access to all projects
        # @return [Array<Sawyer::Resource>] Collaborator details
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/bulk-invite-collaborators
        def invite_collaborators(org_id, emails, options = {})
          case emails
          when String
            post "organizations/#{org_id}/collaborators", options.merge({:email => emails})
          when Array
            post "organizations/#{org_id}/collaborators/bulk_invite", options.merge({:emails => emails})
          else
            raise ArgumentError, "Emails must be a String or an Array"
          end
        end

        # Update a Collaborator's permissions
        #
        # @option project_ids [Array<String>] Ids in the organziation the user should have access to
        # @option admin [Boolean]  Whether to give admin permissions. Admins have access to all projects
        # @return [Sawyer::Resource] Collaborator details
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/update-a-collaborator's-permissions
        def update_collaborator_permissions(org_id, id, options = {})
          patch "organizations/#{org_id}/collaborators/#{id}", options
        end

        # Delete a Collaborator
        #
        # @return
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/delete-a-collaborator
        def delete_collaborator(org_id, id, options = {})
          boolean_from_response :delete, "organizations/#{org_id}/collaborators/#{id}", options
        end

        # View Projects a Collaborator has access to
        #
        # @option sort [String] Which field to sort the results by.  Possible values: created_at
        # @option direction [String] Which direction to sort the results by.  Possible values: asc, desc
        # @option per_page [Number] Number of results per page
        # @return [Array<Sawyer::Resource>] A list of projects the collaborator belongs to
        # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/view-projects-a-collaborator-has-access-to
        def view_collaborator_projects(org_id, id, options = {})
          paginate "organizations/#{org_id}/collaborators/#{id}/projects", options
        end
      end
    end
  end
end
  