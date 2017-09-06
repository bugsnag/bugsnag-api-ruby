require "spec_helper"

describe Bugsnag::Api::Client::Projects do
    before do
        @client = auth_token_client
        @org_id = test_bugsnag_org_id
        Bugsnag::Api.reset!
    end

    describe ".create_project", :vcr do
        it "creates a new project" do
        new_project = @client.create_project @org_id, "testProject", "other"
        expect(new_project.name).to eq(@new_project_name)

        assert_requested :post, bugsnag_url("/organizations/#{@org_id}/projects")
        end
    end

    context "given a project" do
        before do
            @project = @client.create_project @org_id, "testProject", "other"
        end

        describe ".view_project" do
            it "returns the requested project" do
                project = @client.view_project @project.id
                expect(project.id).to eq(@project.id)
                expect(project.name).to eq("testProject")

                assert_requested :get, bugsnag_url("/projects/#{@project.id}")
            end
        end

        describe ".update_project", :vcr do
            it "updates and returns the project" do
                updated_project = @client.update_project @project.id, {:name => "otherName"}
                expect(updated_project.id).to eq(@project.id)
                expect(updated_project.name).to eq("otherName")

                assert_requested :patch, bugsnag_url("/projects/#{@project.id}")
            end
        end

        describe ".regenerate_api_key", :vcr do
            it "removes the current api key and replaces it with a new api key" do
                updated_project = @client.regenerate_api_key @project.id
                expect(updated_project.id).to eq(@project.id)
                expect(updated_project.api_key).not_to eq(@project.api_key)
                
                assert_requested :delete, bugsnag_url("/projects/#{@project.id}/api_key")
            end
        end
        
        describe ".delete_project", :vcr do
            it "deletes the project" do
                deleted_project = @client.delete_project @project.id
                expect(deleted_project).to be true

                assert_requested :delete, bugsnag_url("/projects/#{@project.id}")
            end
        end
    end

end
