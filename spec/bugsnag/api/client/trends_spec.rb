require "spec_helper"

describe Bugsnag::Api::Client::Trends do
  before do
    @project_id = test_bugsnag_project_id
    @error_id = test_bugsnag_error_id
    @client = auth_token_client
    Bugsnag::Api.reset!
  end

  describe ".trends_buckets", :vcr do
    it "returns a list of error trends in bucket form" do
      trends = @client.trends_buckets @project_id, 5, @error_id
      expect(trends).to be_a_kind_of(Array)
      expect(trends.length).to eq(5)

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/trend?buckets_count=5")
    end

    it "returns a list of project trends in bucket form" do
      trends = @client.trends_buckets @project_id, 5
      expect(trends).to be_a_kind_of(Array)
      expect(trends.length).to eq(5)

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/trend?buckets_count=5")
    end
  end

  describe ".trends_resolution", :vcr do
    it "returns a list of trends in resolution form" do
      trends = @client.trends_resolution @project_id, "12h", @error_id

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/trend?resolution=12h")
    end

    it "returns a list of project trends in resolution form" do
      trends = @client.trends_resolution @project_id, "12h"
      expect(trends).to be_a_kind_of(Array)
      expect(trends.length).to be > 0

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/trend?resolution=12h")
    end
  end
end
