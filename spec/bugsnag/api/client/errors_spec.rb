require "spec_helper"

describe Bugsnag::Api::Client::Errors do
  before do
    Bugsnag::Api.reset!
    @client = auth_token_client
  end

  describe ".errors" do
    it "returns all errors on an project" do
      errors = @client.errors(test_bugsnag_project)
      expect(errors).to be_kind_of(Array)
      expect(errors.first.class).not_to be_nil

      assert_requested :get, bugsnag_url("/projects/#{test_bugsnag_project}/errors")
    end
  end

  context "with error" do
    let(:error_url) { bugsnag_url("/errors/#{test_bugsnag_error}") }

    describe ".error" do
      it "returns an error" do
        error = @client.error(test_bugsnag_error)
        expect(error.class).not_to be_nil

        assert_requested :get, error_url
      end
    end

    describe ".resolve_error" do
      it "resolves the error" do
        error = @client.resolve_error(test_bugsnag_error)
        expect(error.resolved).to be true

        assert_requested :patch, error_url
      end
    end

    describe ".reopen_error" do
      it "reopens the error" do
        error = @client.reopen_error(test_bugsnag_error)
        expect(error.resolved).to be false

        assert_requested :patch, error_url
      end
    end

    describe ".update_error" do
      it "updates the error" do
        error = @client.update_error(test_bugsnag_error, :resolved => true)
        expect(error.resolved).to be true

        assert_requested :patch, error_url
      end
    end

    describe ".delete_error" do
      it "deletes the error" do
        stub_request(:delete, error_url).to_return(:status => [204, "No Content"])

        response = @client.delete_error(test_bugsnag_error)
        expect(response).to be true

        assert_requested :delete, error_url
      end
    end
  end
end
