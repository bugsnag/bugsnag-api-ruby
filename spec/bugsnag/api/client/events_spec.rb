require "spec_helper"

describe Bugsnag::Api::Client::Events do
  before do
    @client = auth_token_client
    @project_id = test_bugsnag_project_id
    @error_id = test_bugsnag_error_id
    @event_id = test_bugsnag_event_id
    Bugsnag::Api.reset!
  end

  describe ".view_event", :vcr do
    it "returns the specified event" do
      event = @client.view_event @project_id, @event_id
      expect(event.id).to_not be_nil
      expect(event.context).to_not be_nil

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/events/#{@event_id}")
    end
  end

  describe ".delete_event", :vcr do
    it "deletes the specified event" do
      stub_request(:delete, bugsnag_url("/projects/#{@project_id}/events/#{@event_id}")).to_return(:status => [204, "No Content"])

      response = @client.delete_event @project_id, @event_id
      expect(response).to be true

      assert_requested :delete, bugsnag_url("/projects/#{@project_id}/events/#{@event_id}")
    end
  end

  describe ".list_error_events", :vcr do
    it "lists all error events" do
      events = @client.list_error_events @project_id, @error_id
      expect(events).to be_a_kind_of(Array)
      expect(events.first.id).to_not be_nil
      expect(events.first.context).to_not be_nil
      
      assert_requested :get, bugsnag_url("/projects/#{@project_id}/errors/#{@error_id}/events")
    end
  end

  describe ".view_latest_event", :vcr do
    it "returns the last event on an error" do
      event = @client.view_latest_event @error_id
      expect(event.id).to_not be_nil
      expect(event.context).to_not be_nil

      assert_requested :get, bugsnag_url("/errors/#{@error_id}/latest_event")
    end
  end

  describe ".list_project_events", :vcr do
    it "returns the a list of project errors" do
      events = @client.list_project_events @project_id
      expect(events).to be_a_kind_of(Array)
      expect(events.first.id).to_not be_nil
      expect(events.first.context).to_not be_nil

      assert_requested :get, bugsnag_url("/projects/#{@project_id}/events")
    end
  end
end
