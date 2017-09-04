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
                def viewCollaborator(org_id, collaborator_id, options = {})
                    get "organizations/#{org_id}/collaborators/#{collaborator_id}", options
                end

                # List Collaborators
                #
                # @option per_page [Number] Amount of results per-page
                # @return [Array<Sawyer::Resource>] List of Collaborators
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/list-collaborators
                def listCollaborators(org_id, options = {})
                    paginate "organizations/#{org_id}/collaborators", options
                end

                # Create a Collaborator
                #
                # @option name [String] The name of the invited user
                # @option password [String] A password for the invited user
                # @option project_ids [Array<String>] The ids in the organization the user should have access to
                # @option admin [Boolean] Whether to give admin permissions. Admins have access to all projects
                # @return [Sawyer::Resource] Collaborator details
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/create-a-collaborator
                def createCollaborator(org_id, email, options = {})
                    post "organizations/#{org_id}/collaborators", options.merge({:email => email})
                end

                # Bulk invite Collaborators
                #
                # @option emails [Array<String>] A list of emails to invite
                # @option project_ids [Array<String>] The ids in the organization the user(s) should have access to
                # @option admin [Boolean] Whether to give admin permissions. Admins have access to all projects
                # @return [Array<Sawyer::Resource>] Collaborator details
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/bulk-invite-collaborators
                def bulkInviteCollaborators(org_id, options = {})
                    post "organizations/#{org_id}/collaborators/bulk_invite", options
                end

                # Update a Collaborator's permissions
                #
                # @option project_ids [Array<String>] Ids in the organziation the user should have access to
                # @option admin [Boolean]  Whether to give admin permissions. Admins have access to all projects
                # @return [Sawyer::Resource] Collaborator details
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/update-a-collaborator's-permissions
                def updateCollaboratorPermissions(org_id, id, options = {})
                    patch "organizations/#{org_id}/collaborators/#{id}", options
                end

                # Delete a Collaborator
                #
                # @return
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/delete-a-collaborator
                def deleteCollaborator(org_id, id, options = {})
                    delete "organizations/#{org_id}/collaborators/#{id}", options
                end

                # List Collaborators on a Project
                #
                # @option per_page [Number] Number of results per page
                # @return [Array<Sawyer::Resource>] A list of users on the project
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/list-collaborators-on-a-project
                def listProjectCollaborators(project_id, options = {})
                    paginate "projects/#{project_id}/collaborators", options
                end

                # View Projects a Collaborator has access to
                #
                # @option sort [String] Which field to sort the results by.  Possible values: created_at
                # @option direction [String] Which direction to sort the results by.  Possible values: asc, desc
                # @option per_page [Number] Number of results per page
                # @return [Array<Sawyer::Resource>] A list of projects the collaborator belongs to
                # @see http://docs.bugsnagapiv2.apiary.io/#reference/organizations/collaborators/view-projects-a-collaborator-has-access-to
                def viewCollaboratorProjects(org_id, id, options = {})
                    paginate "organizations/#{org_id}/collaborators/#{id}/projects", options
                end
            end
        end
    end
end
  