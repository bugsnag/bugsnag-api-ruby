require "spec_helper"

describe Bugsnag::Api::Client::Users do
  before do
    Bugsnag::Api.reset!
    @client = auth_token_client
  end

  describe ".account_users" do
    it "returns all users on the authed account" do
      users = @client.account_users
      expect(users).to be_kind_of(Array)
      expect(users.first.email).not_to be_nil

      assert_requested :get, bugsnag_url("/account/users")
    end

    it "raises when authed with user credentials" do
      client = Bugsnag::Api::Client.new(:email => "blah", :password => "blah")
      expect { client.account_users }.to raise_error Bugsnag::Api::AccountCredentialsRequired

      assert_not_requested :get, bugsnag_url("/account/users")
    end

    it "returns all users on an account", :beta do
      users = @client.account_users(test_bugsnag_account)
      expect(users).to be_kind_of(Array)
      expect(users.first.email).not_to be_nil

      assert_requested :get, bugsnag_url("/accounts/#{test_bugsnag_account}/users")
    end
  end

  describe ".project_users" do
    it "returns all users for a project" do
      users = @client.project_users(test_bugsnag_project)
      expect(users).to be_kind_of(Array)
      expect(users.first.email).not_to be_nil

      assert_requested :get, bugsnag_url("/projects/#{test_bugsnag_project}/users")
    end
  end

  describe ".invite_user" do
    it "invites a user to an account", :beta do
      user = @client.invite_user(test_bugsnag_account, "example@example.com")
      expect(user.email).to eq("example@example.com")

      assert_requested :post, bugsnag_url("/accounts/#{test_bugsnag_account}/users")
    end
  end

  context "with user", :beta do
    before do
      @user = @client.invite_user(test_bugsnag_account, "example@example.com", :admin => false)
    end

    describe ".user" do
      it "returns a user" do
        user = @client.user(@user.id)
        expect(user.id).to eq(@user.id)

        assert_requested :get, bugsnag_url("/users/#{@user.id}")
      end
    end

    describe ".update_user_permissions" do
      it "updates a users permissions" do
        updated_user = @client.update_user_permissions(test_bugsnag_account, @user.id, :admin => true)
        expect(updated_user.account_admin).to eq(true)
        assert_requested :patch, bugsnag_url("/accounts/#{test_bugsnag_account}/users/#{@user.id}")
      end
    end

    describe ".remove_user" do
      it "removes a user from an account" do
        response = @client.remove_user(test_bugsnag_account, @user.id)
        expect(response).to be_true
        assert_requested :delete, bugsnag_url("/accounts/#{test_bugsnag_account}/users/#{@user.id}")
      end
    end
  end
end
