require "spec_helper"

describe Bugsnag::Api::Client::Errors do
  before do
    @client = auth_token_client
    @project_id = test_bugsnag_project_id
    @error_id = test_bugsnag_error_id
    Bugsnag::Api.reset!
  end

  describe ".errors", :vcr do
    it "returns errors on the project" do
      errors = @client.errors @project_id
      expect(errors).to be_a_kind_of(Array)
      expect(errors.first.id).to_not be_nil
      expect(errors.first.context).to_not be_nil

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors")
    end
  end

  describe ".error", :vcr do
    it "returns a single error" do
      error = @client.error @project_id, @error_id
      expect(error.id).to_not be_nil
      expect(error.context).to_not be_nil

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}")
    end
  end

  describe ".update_errors", :vcr do
    it "updates and returns the updated error" do
      skip "overridden_severity not being updated through API"
      error = @client.update_errors @project_id, @error_id, "open", {:severity => "info"}
      expect(error.id).to_not be_nil
      expect(error.context).to_not be_nil
      expect(error.severity).to eq("info")
      expect(error.status).to eq("open")

      assert_requested :patch, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}")
    end
    
    it "updates and returns the updated errors" do
      errors = @client.update_errors @project_id, [@error_id, @error_id], "fix", {:severity => "warn"}
      expect(errors.operation).to_not be_nil
      expect(errors[@error_id].status).to eq("fixed")

      assert_requested :patch, bugsnag_url("/projects/#{@project_id}/errors?error_ids[]=#{@error_id}&error_ids[]=#{@error_id}")
    end
  end

  describe ".delete_errors" do
    it "deletes the error and returns true" do
      stub_request(:delete, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}")).to_return(:status => [204, "No Content"])
      
      response = @client.delete_errors @project_id, @error_id
      expect(response).to be true

      assert_requested :delete, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}")
    end

    it "deletes all errors and returns true" do
      stub_request(:delete, bugsnag_url("/projects/#{@project_id}/errors")).to_return(:status => [204, "No Content"])

      response = @client.delete_errors @project_id
      expect(response).to be true

      assert_requested :delete, bugsnag_url("/projects/#{@project_id}/errors")
    end
  end
end
