require "spec_helper"

describe Bugsnag::Api::Client::Stability do
  before do
    @client = auth_token_client
    @project_id = test_bugsnag_project_id

    Bugsnag::Api.reset!
  end

  describe ".stability_trend", :vcr do
    it "gets the stability trend" do
      stability_trend = @client.stability_trend(@project_id)

      expect(stability_trend.project_id).to eq(@project_id)
      expect(stability_trend.release_stage_name).not_to be_nil
      expect(stability_trend.timeline_points).to be_an_instance_of(Array)

      # convert each "Sawyer::Resource" to a hash so we can use the "have_key" matcher
      timeline_points = stability_trend.timeline_points.map(&:to_h)

      expect(timeline_points).to all have_key(:bucket_start)
      expect(timeline_points).to all have_key(:bucket_end)
      expect(timeline_points).to all have_key(:total_sessions_count)
      expect(timeline_points).to all have_key(:unhandled_sessions_count)
      expect(timeline_points).to all have_key(:users_seen)
      expect(timeline_points).to all have_key(:users_with_unhandled)

      assert_requested(:get, bugsnag_url("/projects/#{@project_id}/stability_trend"))
    end
  end
end
