require "spec_helper"

describe Bugsnag::Api::Client::Users do
  before do
    Bugsnag::Api.reset!
    @client = basic_auth_client
  end

  describe ".account_users", :vcr do
    context "when using account credentials" do
      it "returns all users" do
        users = auth_token_client.account_users
        expect(users).to be_kind_of(Array)
        expect(users.first.email).not_to be_nil

        assert_requested :get, bugsnag_url("/account/users")
      end
    end

    context "when using user credentials" do
      it "raises an error" do
        expect { @client.account_users }.to raise_error Bugsnag::Api::AccountCredentialsRequired

        assert_not_requested :get, basic_bugsnag_url("/account/users")
      end
    end

    it "returns all users on an account" do
      users = @client.account_users(test_bugsnag_account)
      expect(users).to be_kind_of(Array)
      expect(users.first.email).not_to be_nil

      assert_requested :get, basic_bugsnag_url("/accounts/#{test_bugsnag_account}/users")
    end
  end

  describe ".project_users", :vcr do
    it "returns all users for a project" do
      users = @client.project_users(test_bugsnag_project)
      expect(users).to be_kind_of(Array)
      expect(users.first.email).not_to be_nil

      assert_requested :get, basic_bugsnag_url("/projects/#{test_bugsnag_project}/users")
    end
  end

  describe ".invite_user", :vcr do
    it "invites a user to an account", :beta do
      user = @client.invite_user(test_bugsnag_account, "example@example.com")
      expect(user.email).to eq("example@example.com")

      assert_requested :post, basic_bugsnag_url("/accounts/#{test_bugsnag_account}/users")
    end
  end

  describe ".user", :vcr do
    context "when using user credentials" do
      it "returns the authed user" do
        user = @client.user
        expect(user.email).not_to be_nil

        assert_requested :get, basic_bugsnag_url("/user")
      end
    end

    context "when using account credentials" do
      it "raises an error" do
        expect { auth_token_client.user }.to raise_error Bugsnag::Api::UserCredentialsRequired

        assert_not_requested :get, bugsnag_url("/user")
      end
    end
  end

  describe ".user", :vcr do
    it "returns a user" do
      user = @client.user(test_bugsnag_user)
      expect(user.id).to eq(test_bugsnag_user)

      assert_requested :get, basic_bugsnag_url("/users/#{test_bugsnag_user}")
    end
  end

  context "with user", :vcr do
    before do
      @user = @client.invite_user(test_bugsnag_account, "example@example.com", :admin => false)
    end

    describe ".update_user_permissions" do
      it "updates a users permissions" do
        updated_user = @client.update_user_permissions(test_bugsnag_account, @user.id, :admin => true)
        expect(updated_user.account_admin).to eq(true)
        assert_requested :patch, basic_bugsnag_url("/accounts/#{test_bugsnag_account}/users/#{@user.id}")
      end
    end

    describe ".remove_user" do
      it "removes a user from an account" do
        response = @client.remove_user(test_bugsnag_account, @user.id)
        expect(response).to be true
        assert_requested :delete, basic_bugsnag_url("/accounts/#{test_bugsnag_account}/users/#{@user.id}")
      end
    end
  end
end
