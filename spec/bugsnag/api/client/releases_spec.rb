require "spec_helper"

describe Bugsnag::Api::Client::Releases do
  before do
    @client = auth_token_client
    @project_id = test_bugsnag_project_id
    @release_id = test_bugsnag_release_id
    @release_group_id = test_bugsnag_release_group_id

    Bugsnag::Api.reset!
  end

  describe ".releases", :vcr do
    it "gets as list of releases" do
      releases = @client.releases(@project_id)

      expect(releases).to be_an_instance_of(Array)

      releases.map!(&:to_h)

      expect(releases.first[:id]).to eq(@release_id)
      expect(releases.first[:project_id]).to eq(@project_id)
      expect(releases.first[:release_group_id]).to eq(@release_group_id)

      expect(releases).to all have_key(:id)
      expect(releases).to all have_key(:project_id)
      expect(releases).to all have_key(:release_group_id)
      expect(releases).to all have_key(:release_time)
      expect(releases).to all have_key(:release_source)
      expect(releases).to all have_key(:app_version)
      expect(releases).to all have_key(:app_version_code)
      expect(releases).to all have_key(:app_bundle_version)
      expect(releases).to all have_key(:build_label)
      expect(releases).to all have_key(:builder_name)
      expect(releases).to all have_key(:build_tool)
      expect(releases).to all have_key(:errors_introduced_count)
      expect(releases).to all have_key(:errors_seen_count)
      expect(releases).to all have_key(:sessions_count_in_last_24h)
      expect(releases).to all have_key(:total_sessions_count)
      expect(releases).to all have_key(:unhandled_sessions_count)
      expect(releases).to all have_key(:accumulative_daily_users_seen)
      expect(releases).to all have_key(:accumulative_daily_users_with_unhandled)
      expect(releases).to all have_key(:metadata)
      expect(releases).to all have_key(:release_stage)
    end

    it "accepts parameters" do
      releases = @client.releases(
        @project_id,
        {
          release_stage: 'development',
          base: '2021-07-21T12:00:00Z',
          sort: 'percent_of_sessions',
          offset: 0,
          per_page: 1
        }
      )

      expect(releases).to be_an_instance_of(Array)

      releases.map!(&:to_h)

      expect(releases.first[:id]).to eq(@release_id)
      expect(releases.first[:project_id]).to eq(@project_id)
      expect(releases.first[:release_group_id]).to eq(@release_group_id)

      expect(releases).to all have_key(:id)
      expect(releases).to all have_key(:project_id)
      expect(releases).to all have_key(:release_group_id)
      expect(releases).to all have_key(:release_time)
      expect(releases).to all have_key(:release_source)
      expect(releases).to all have_key(:app_version)
      expect(releases).to all have_key(:app_version_code)
      expect(releases).to all have_key(:app_bundle_version)
      expect(releases).to all have_key(:build_label)
      expect(releases).to all have_key(:builder_name)
      expect(releases).to all have_key(:build_tool)
      expect(releases).to all have_key(:errors_introduced_count)
      expect(releases).to all have_key(:errors_seen_count)
      expect(releases).to all have_key(:sessions_count_in_last_24h)
      expect(releases).to all have_key(:total_sessions_count)
      expect(releases).to all have_key(:unhandled_sessions_count)
      expect(releases).to all have_key(:accumulative_daily_users_seen)
      expect(releases).to all have_key(:accumulative_daily_users_with_unhandled)
      expect(releases).to all have_key(:metadata)
      expect(releases).to all have_key(:release_stage)
    end
  end

  describe ".release", :vcr do
    it "gets a single release" do
      release = @client.release(@project_id, @release_id)

      expect(release.id).to eq(@release_id)
      expect(release.project_id).to eq(@project_id)
      expect(release.release_group_id).to eq(@release_group_id)
      expect(release.release_time).not_to be_nil
      expect(release.release_source).not_to be_nil
      expect(release.app_version).not_to be_nil
      expect(release.app_version_code).not_to be_nil
      expect(release.app_bundle_version).not_to be_nil
      expect(release.build_label).not_to be_nil
      expect(release.builder_name).not_to be_nil
      expect(release.build_tool).not_to be_nil
      expect(release.errors_introduced_count).not_to be_nil
      expect(release.errors_seen_count).not_to be_nil
      expect(release.sessions_count_in_last_24h).not_to be_nil
      expect(release.total_sessions_count).not_to be_nil
      expect(release.unhandled_sessions_count).not_to be_nil
      expect(release.accumulative_daily_users_seen).not_to be_nil
      expect(release.accumulative_daily_users_with_unhandled).not_to be_nil
      expect(release.metadata).not_to be_nil
      expect(release.release_stage).not_to be_nil
    end
  end

  describe ".release_groups", :vcr do
    it "gets releases in a release group" do
      releases = @client.releases_in_group(@release_group_id)

      expect(releases).to be_an_instance_of(Array)

      releases.map!(&:to_h)

      expect(releases.first[:id]).to eq(@release_id)
      expect(releases.first[:project_id]).to eq(@project_id)
      expect(releases.first[:release_group_id]).to eq(@release_group_id)

      expect(releases).to all have_key(:id)
      expect(releases).to all have_key(:project_id)
      expect(releases).to all have_key(:release_group_id)
      expect(releases).to all have_key(:release_time)
      expect(releases).to all have_key(:release_source)
      expect(releases).to all have_key(:app_version)
      expect(releases).to all have_key(:app_version_code)
      expect(releases).to all have_key(:app_bundle_version)
      expect(releases).to all have_key(:build_label)
      expect(releases).to all have_key(:builder_name)
      expect(releases).to all have_key(:build_tool)
      expect(releases).to all have_key(:errors_introduced_count)
      expect(releases).to all have_key(:errors_seen_count)
      expect(releases).to all have_key(:sessions_count_in_last_24h)
      expect(releases).to all have_key(:total_sessions_count)
      expect(releases).to all have_key(:unhandled_sessions_count)
      expect(releases).to all have_key(:accumulative_daily_users_seen)
      expect(releases).to all have_key(:accumulative_daily_users_with_unhandled)
      expect(releases).to all have_key(:metadata)
      expect(releases).to all have_key(:release_stage)
    end

    it "accepts parameters" do
      releases = @client.releases_in_group(@release_group_id, { per_page: 1 })

      expect(releases).to be_an_instance_of(Array)

      releases.map!(&:to_h)

      expect(releases.first[:id]).to eq(@release_id)
      expect(releases.first[:project_id]).to eq(@project_id)
      expect(releases.first[:release_group_id]).to eq(@release_group_id)

      expect(releases).to all have_key(:id)
      expect(releases).to all have_key(:project_id)
      expect(releases).to all have_key(:release_group_id)
      expect(releases).to all have_key(:release_time)
      expect(releases).to all have_key(:release_source)
      expect(releases).to all have_key(:app_version)
      expect(releases).to all have_key(:app_version_code)
      expect(releases).to all have_key(:app_bundle_version)
      expect(releases).to all have_key(:build_label)
      expect(releases).to all have_key(:builder_name)
      expect(releases).to all have_key(:build_tool)
      expect(releases).to all have_key(:errors_introduced_count)
      expect(releases).to all have_key(:errors_seen_count)
      expect(releases).to all have_key(:sessions_count_in_last_24h)
      expect(releases).to all have_key(:total_sessions_count)
      expect(releases).to all have_key(:unhandled_sessions_count)
      expect(releases).to all have_key(:accumulative_daily_users_seen)
      expect(releases).to all have_key(:accumulative_daily_users_with_unhandled)
      expect(releases).to all have_key(:metadata)
      expect(releases).to all have_key(:release_stage)
    end
  end
end
