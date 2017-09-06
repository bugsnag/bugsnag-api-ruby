require "spec_helper"

describe Bugsnag::Api::Client::CurrentUser do
  before do
    Bugsnag::Api.reset!
  end

  describe ".list_current_users_organizations", :vcr do
    context "when using user credentials" do
      it "returns users organizations" do
        client = basic_auth_client
        organizations = client.list_current_users_organizations
        expect(organizations).to be_kind_of(Array)
        expect(organizations.first.name).not_to be_nil

        assert_requested :get, bugsnag_url("/user/organizations")
      end
    end
    context "when using auth token" do
      it "returns the organization the auth token belongs to" do
        client = auth_token_client
        organizations = client.list_current_users_organizations
        expect(organizations).to be_kind_of(Array)
        expect(organizations.length).to eq(1)
        expect(organizations.first.name).not_to be_nil

        assert_requested :get, bugsnag_url("/user/organizations")
      end
    end
  end

  describe ".list_current_users_projects", :vcr do
    context "when using auth token" do
      it "lists current user's projects in the organization" do
        client = auth_token_client
        org_id = test_bugsnag_org_id
        projects = client.list_current_users_projects org_id
        expect(projects).to be_kind_of(Array)
        expect(projects.first.name).not_to be_nil

        assert_requested :get, bugsnag_url("/organizations/#{org_id}/projects")
      end
    end

    context "when using user credentials" do
      it "lists current user's projects in the organization" do
        client = basic_auth_client
        org_id = test_bugsnag_org_id
        projects = client.list_current_users_projects org_id
        expect(projects).to be_kind_of(Array)
        expect(projects.first.name).not_to be_nil

        assert_requested :get, bugsnag_url("/organizations/#{org_id}/projects")
      end
    end
  end
end
