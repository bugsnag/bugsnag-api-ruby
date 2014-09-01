require "spec_helper"

describe Bugsnag::Api::Client::Events do
  before do
    Bugsnag::Api.reset!
    @client = auth_token_client
  end

  describe ".project_events" do
    it "returns all events on a project" do
      events = @client.project_events(test_bugsnag_project)
      expect(events).to be_kind_of(Array)
      expect(events.first.context).not_to be_nil

      assert_requested :get, bugsnag_url("/projects/#{test_bugsnag_project}/events")
    end
  end

  describe ".error_events" do
    it "returns all events on an error" do
      events = @client.error_events(test_bugsnag_error)
      expect(events).to be_kind_of(Array)
      expect(events.first.context).not_to be_nil

      assert_requested :get, bugsnag_url("/errors/#{test_bugsnag_error}/events")
    end
  end

  context "with event" do
    let(:event_url) { bugsnag_url("/events/#{test_bugsnag_event}") }

    describe ".event" do
      it "returns an event" do
        event = @client.event(test_bugsnag_event)
        expect(event.context).not_to be_nil

        assert_requested :get, event_url
      end
    end

    describe ".delete_event" do
      it "deletes the event" do
        stub_request(:delete, event_url).to_return(:status => [204, "No Content"])

        response = @client.delete_event(test_bugsnag_event)
        expect(response).to be true

        assert_requested :delete, event_url
      end
    end
  end
end
