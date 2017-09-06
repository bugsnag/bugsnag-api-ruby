require "spec_helper"

describe Bugsnag::Api::Client::Pivots do
    before do
        @client = auth_token_client
        @project_id = test_bugsnag_project_id
        @error_id = test_bugsnag_error_id
        @event_field_id = test_bugsnag_eventfield_id
        Bugsnag::Api.reset!
    end

    describe ".list_error_pivots", :vcr do
        it "returns a list of pivots on an error" do
            pivots = @client.list_error_pivots @project_id, @error_id
            expect(pivots).to be_a_kind_of(Array)
            expect(pivots.length).to be > 0

            assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/pivots")
        end
    end

    describe ".list_error_pivot_values", :vcr do
        it "returns values of pivots on an error" do
            values = @client.list_error_pivot_values @project_id, @error_id, @event_field_id
            expect(values).to be_a_kind_of(Array)
            expect(values.length).to be > 0

            assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/pivots/#{@event_field_id}/values")
        end
    end

    describe ".list_project_pivots", :vcr do
        it "returns a list of pivots on a project" do
            pivots = @client.list_project_pivots @project_id
            expect(pivots).to be_a_kind_of(Array)
            expect(pivots.length).to be > 0
            
            assert_requested :get, bugsnag_url("/projects/#{@project_id}/pivots")
        end
    end

    describe ".list_project_pivot_values", :vcr do
        it "returns values of pivots on a project" do
            values = @client.list_project_pivot_values @project_id, @event_field_id
            expect(values).to be_a_kind_of(Array)
            expect(values.length).to be > 0

            assert_requested :get, bugsnag_url("/projects/#{@project_id}/pivots/#{@event_field_id}/values")
        end
    end
end

