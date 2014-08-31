require "spec_helper"

describe Bugsnag::Api::Client::Users do
  before do
    Bugsnag::Api.reset!
    @client = auth_token_client
  end

  # TODO
end
