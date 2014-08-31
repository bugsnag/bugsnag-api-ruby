require "spec_helper"

describe Bugsnag::Api::Client::Accounts do
  before do
    Bugsnag::Api.reset!
    @client = auth_token_client
  end

  describe ".accounts" do
    it "returns all accounts", :beta do
      accounts = @client.accounts
      expect(accounts).to be_kind_of(Array)
      expect(accounts.first.name).not_to be_nil

      assert_requested :get, bugsnag_url("/accounts")
    end
  end

  describe ".account" do
    it "returns the account when authed with account credentials" do
      account = @client.account
      expect(account.name).not_to be_nil

      assert_requested :get, bugsnag_url("/account")
    end

    it "raises when authed with user credentials" do
      client = Bugsnag::Api::Client.new(:email => "blah", :password => "blah")
      expect { client.account }.to raise_error Bugsnag::Api::AccountCredentialsRequired

      assert_not_requested :get, bugsnag_url("/account")
    end

    it "returns the requested account", :beta do
      account = @client.account(test_bugsnag_account)
      expect(account.id).to eq(test_bugsnag_account)

      assert_requested :get, bugsnag_url("/accounts/#{test_bugsnag_account}")
    end
  end
end
