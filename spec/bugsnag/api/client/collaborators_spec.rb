require "spec_helper"

describe Bugsnag::Api::Client::Collaborators do
    before do
        @client = auth_token_client
        @organization_id = test_bugsnag_org_id
        @project_id = test_bugsnag_project_id
        @collaborator_email = test_bugsnag_collaborator
        @admin_email = test_bugsnag_email
        Bugsnag::Api.reset!
    end

    describe ".create_collaborator", :vcr do
        it "creates and returns a collaborator" do
            collaborator = @client.create_collaborator @organization_id, @collaborator_email
            expect(collaborator.email).to eq(collaborator)

            assert_requested :post, bugsnag_url("/organizations/#{@organization_id}/collaborators")
        end
    end

    describe ".bulk_invite_collaborators", :vcr do
        it "invites multiple collaborators" do
            collaborators = @client.bulk_invite_collaborators @organization_id, {:emails => [@collaborator_email, @admin_email]} 
            expect(collaborators).to be_a_kind_of(Array)
            expect(collaborators.length).to eq(2)

            assert_requested :post, bugsnag_url("/organizations/#{@organization_id}/collaborators/bulk_invite")
        end
    end

    context "given a collaborator exists" do
        before do
            @collaborator = @client.create_collaborator @organization_id, @collaborator_email, {:project_ids => [@project_id]}
        end

        describe ".view_collaborator", :vcr do
            it "returns a collaborator" do
                collaborator = @client.view_collaborator @organization_id, @collaborator.id
                expect(collaborator.id).to eq(@collaborator.id)
                expect(collaborator.name).to eq(@collaborator.name)

                assert_requested :get, bugsnag_url("/organizations/#{@organization_id}/collaborators/#{@collaborator.id}")
            end
        end

        describe ".list_collaborators", :vcr do
            it "returns a list of all organization collaborators" do
                collaborators = @client.list_collaborators @organization_id
                expect(collaborators).to be_a_kind_of(Array)
                expect(collaborators.length).to be > 1
            
                assert_requested :get, bugsnag_url("/organizations/#{@organization_id}/collaborators")
            end
        end

        describe ".list_project_collaborators", :vcr do
            it "returns a list of all project collaborators" do
                collaborators = @client.list_project_collaborators @project_id
                expect(collaborators).to be_a_kind_of(Array)
                expect(collaborators.length).to be > 1

                assert_requested :get, bugsnag_url("/projects/#{@project_id}/collaborators"
            end
        end

        describe ".view_collaborator_projects", :vcr do
            it "returns a list of projects belonging to the collaborator" do
                projects = @client.view_collaborator_projects @organization_id, @collaborator.id
                expect(projects).to be_a_kind_of(Array)
                expect(projects.length).to be > 0

                assert_requested :get, bugsnag_url("/organizations/#{@organization_id}/collaborators/#{@collaborator.id}/projects")
            end
        end

        describe ".update_collaborator_permissions", :vcr do
            it "updates and returns the collaborator" do
                collaborator = @client.update_collaborator_permissions @organization_id, @collaborator.id, {:admin => true}
                expect(collaborator.id).to eq(@collaborator.id)
                expect(collaborator.is_admin).to be true

                assert_requested :patch, bugsnag_url("/organizations/#{@organization_id}/collaborators/#{@collaborator.id}")
            end
        end

        describe ".delete_collaborator", :vcr do
            it "deletes a collaborator" do
                collaborator = @client.delete_collaborator @organization_id, @collaborator.id
                expect(collaborator).to be true

                assert_requested :delete, bugsnag_url("/organizations/#{@organization_id}/collaborators/#{@collaborator.id}")
            end
        end
    end         
end
