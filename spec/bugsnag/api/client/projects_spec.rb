require "spec_helper"

describe Bugsnag::Api::Client::Projects do
  before do
    Bugsnag::Api.reset!
    @client = auth_token_client
  end

  describe ".account_projects" do
    it "returns all projects on the authed account" do
      projects = @client.account_projects
      expect(projects).to be_kind_of(Array)
      expect(projects.first.name).not_to be_nil

      assert_requested :get, bugsnag_url("/account/projects")
    end

    it "raises when authed with user credentials" do
      client = Bugsnag::Api::Client.new(:email => "blah", :password => "blah")
      expect { client.account_projects }.to raise_error Bugsnag::Api::AccountCredentialsRequired

      assert_not_requested :get, bugsnag_url("/account/projects")
    end

    it "returns all projects on an account", :beta do
      projects = @client.account_projects(test_bugsnag_account)
      expect(projects).to be_kind_of(Array)
      expect(projects.first.name).not_to be_nil

      assert_requested :get, bugsnag_url("/accounts/#{test_bugsnag_account}/projects")
    end
  end

  describe ".user_projects" do
    it "returns all projects for a user" do
      projects = @client.user_projects(test_bugsnag_user)
      expect(projects).to be_kind_of(Array)
      expect(projects.first.name).not_to be_nil

      assert_requested :get, bugsnag_url("/users/#{test_bugsnag_user}/projects")
    end
  end

  describe ".create_project" do
    it "creates a project on the authed account" do
      project = @client.create_project(:name => "Example")
      expect(project.name).to eq("Example")

      assert_requested :post, bugsnag_url("/account/projects")
    end

    it "creates a project on an account", :beta do
      project = @client.create_project(test_bugsnag_account, :name => "Example")
      expect(project.name).to eq("Example")

      assert_requested :post, bugsnag_url("/accounts/#{test_bugsnag_account}/projects")
    end
  end

  context "with project", :beta do
    before do
      @project = @client.create_project(test_bugsnag_account, :name => "Example")
    end

    describe ".project" do
      it "returns a project" do
        project = @client.project(@project.id)
        expect(project.id).to eq(@project.id)

        assert_requested :get, bugsnag_url("/projects/#{@project.id}")
      end
    end

    describe ".update_project" do
      it "updates an existing project" do
        new_name = Faker::Name.name

        updated_project = @client.update_project(@project.id, :name => new_name)
        expect(updated_project.name).to eq(new_name)
        assert_requested :patch, bugsnag_url("/projects/#{@project.id}")
      end
    end

    describe ".delete_project" do
      it "deletes an existing project" do
        response = @client.delete_project(@project.id)
        expect(response).to be_true
        assert_requested :delete, bugsnag_url("/projects/#{@project.id}")
      end
    end
  end
end
