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

  describe ".invitecollaborator", :vcr do
    it "creates and returns a collaborator" do
      collaborator = @client.invite_collaborators @organization_id, @collaborator_email
      expect(collaborator.email).to eq(@collaborator_email)

      assert_requested :post, bugsnag_url("/organizations/#{@organization_id}/collaborators")
    end
    
    it "invites multiple collaborators" do
      collaborators = @client.invite_collaborators @organization_id, [@collaborator_email, @admin_email] 
      expect(collaborators).to be_a_kind_of(Array)
      expect(collaborators.length).to eq(2)

      assert_requested :post, bugsnag_url("/organizations/#{@organization_id}/collaborators/bulk_invite")
    end
  end

  context "given a collaborator exists", :vcr do
    before do
      @collaborator = @client.invite_collaborators @organization_id, @collaborator_email, {:project_ids => [@project_id]}
    end

    describe ".collaborator", :vcr do
      it "returns a collaborator" do
        collaborator = @client.collaborator @organization_id, @collaborator.id
        expect(collaborator.id).to eq(@collaborator.id)
        expect(collaborator.name).to eq(@collaborator.name)

        assert_requested :get, bugsnag_url("/organizations/#{@organization_id}/collaborators/#{@collaborator.id}")
      end
    end

    describe ".collaborators", :vcr do
      it "returns a list of all organization collaborators" do
        collaborators = @client.collaborators @organization_id
        expect(collaborators).to be_a_kind_of(Array)
        expect(collaborators.length).to be > 1
    
        assert_requested :get, bugsnag_url("/organizations/#{@organization_id}/collaborators")
      end

      it "returns a list of all project collaborators" do
        collaborators = @client.collaborators(nil, @project_id)
        expect(collaborators).to be_a_kind_of(Array)
        expect(collaborators.length).to be > 1

        assert_requested :get, bugsnag_url("/projects/#{@project_id}/collaborators")
      end

      it "throws an argument error if neither org_id or project_id are provided" do
        begin
          @client.collaborators
        rescue Exception => ex
          expect(ex).to be_a_kind_of(ArgumentError)
        end
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
        stub_request(:delete, bugsnag_url("/organizations/#{@organization_id}/collaborators/#{@collaborator.id}")).to_return(:status => [204, "No Content"])
        collaborator = @client.delete_collaborator @organization_id, @collaborator.id
        expect(collaborator).to be true

        assert_requested :delete, bugsnag_url("/organizations/#{@organization_id}/collaborators/#{@collaborator.id}")
      end
    end
  end
end
