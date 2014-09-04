require "spec_helper"

describe Bugsnag::Api::Client::Accounts do
  before do
    Bugsnag::Api.reset!
    @client = basic_auth_client
  end

  describe ".accounts", :vcr do
    it "returns all accounts" do
      accounts = @client.accounts
      expect(accounts).to be_kind_of(Array)
      expect(accounts.first.name).not_to be_nil

      assert_requested :get, basic_bugsnag_url("/accounts")
    end
  end

  describe ".account", :vcr do
    context "when using account credentials" do
      it "returns the account" do
        client = auth_token_client
        account = client.account
        expect(account.name).not_to be_nil

        assert_requested :get, bugsnag_url("/account")
      end
    end

    context "when using user credentials" do
      it "raises an error" do
        expect { @client.account }.to raise_error Bugsnag::Api::AccountCredentialsRequired

        assert_not_requested :get, basic_bugsnag_url("/account")
      end
    end

    it "returns the requested account" do
      account = @client.account(test_bugsnag_account)
      expect(account.id).to eq(test_bugsnag_account)

      assert_requested :get, basic_bugsnag_url("/accounts/#{test_bugsnag_account}")
    end
  end
end
