require "spec_helper"

describe Bugsnag::Api::Client::Organizations do
  before do
    @client = basic_auth_client
    Bugsnag::Api.reset!
  end

  describe ".create_organization", :vcr do
    it "creates a new organization" do
      organization = @client.create_organization "testOrg"
      expect(organization).to be_kind_of(Object)
      expect(organization.name).to eq("testOrg")

      assert_requested :post, bugsnag_url("/organizations")
    end
  end

  context "with organization", :vcr do
    before do
      @organization = @client.create_organization "testOrg"
    end

    describe ".organization", :vcr do
      it "returns the requested organization" do
        organization = @client.organization @organization.id
        expect(organization.id).to eq(@organization.id)

        assert_requested :get, bugsnag_url("/organizations/#{@organization.id}")
      end
    end

    describe ".update_organization", :vcr do
      it "updates and returns the organization" do
        updatedOrg = @client.update_organization @organization.id, "updated_name", false, {:invoice_address => "test_string"}
        expect(updatedOrg.id).to eq(@organization.id)
        expect(updatedOrg.name).to eq("updated_name")
        expect(updatedOrg.auto_upgrade).to be false

        assert_requested :patch, bugsnag_url("/organizations/#{@organization.id}")
      end
    end

    describe ".delete_organization", :vcr do
      it "deletes the organization" do
        deletedOrg = @client.delete_organization @organization.id
        expect(deletedOrg).to be true
      
        assert_requested :delete, bugsnag_url("/organizations/#{@organization.id}")
      end
    end
  end
end
