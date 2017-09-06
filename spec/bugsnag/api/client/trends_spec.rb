require "spec_helper"

describe Bugsnag::Api::Client::Trends do
    before do
        @project_id = test_bugsnag_project_id
        @error_id = test_bugsnag_error_id
        @client = auth_token_client
        Bugsnag::Api.reset!
    end

    describe ".list_error_trends_buckets", :vcr do
        it "returns a list of error trends in bucket form" do
            trends = @client.list_error_trends_buckets @project_id, @error_id, 10
            expect(trends).to be_a_kind_of(Array)
            expect(trends.length).to eq(5)

            assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/trend")
        end
    end

    describe ".list_error_trends_resolution", :vcr do
        it "returns a list of trends in resolution form" do
            trends = @client.list_error_trends_resolution @project_id, @error_id, "12h"

            assert_requested :get, "/projects/#{@project_id}/errors/#{@error_id}/trend"
        end
    end


    describe ".list_project_trends_buckets", :vcr do
        it "returns a list of project trends in bucket form" do
            trends = @client.list_project_trends_buckets @project_id, 10
            expect(trends).to be_a_kind_of(Array)
            expect(trends.length).to eq(5)

            assert_requested :get, bugsnag_url("/projects/#{@project_id}/trend")
        end
    end
    
    describe ".list_project_trends_resolution", :vcr do
        it "returns a list of project trends in resolution form" do
            trends = @client.list_project_trends_resolution @project_id, "12h"
            expect(trends).to be_a_kind_of(Array)
            expect(trends.length).to be > 0

            assert_requested :get bugsnag_url("/projects/#{@project_id}/trend")
        end
    end
end
