require "json"

describe Bugsnag::Api::Client do
  before do
    Bugsnag::Api.reset!
  end

  after do
    Bugsnag::Api.reset!
  end

  describe "initializer" do
    it "should accept valid configuration options" do
      client = Bugsnag::Api::Client.new(:endpoint => "http://example.com")
      expect(client.configuration.endpoint).to eq("http://example.com")
    end

    it "should ignore junk configuration options" do
      Bugsnag::Api::Client.new(:junk => "junk")
    end
  end

  describe ".configure" do
    it "accepts block-level configuration options" do
      client = Bugsnag::Api::Client.new
      client.configure do |config|
        config.auth_token = "123456"
      end

      expect(client.configuration.auth_token).to eq("123456")
    end
  end

  describe ".configuration" do
    it "exposes the client's configuration" do
      client = Bugsnag::Api::Client.new
      expect(client.configuration).to be_kind_of(Bugsnag::Api::Configuration)
    end
  end

  describe ".get" do
    before(:each) do
      Bugsnag::Api.reset!
    end

    it "handles query params", :vcr do
      Bugsnag::Api.get "/", :foo => "bar"
      assert_requested :get, "https://api.bugsnag.com?foo=bar"
    end

    it "handles headers" do
      request = stub_get("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Bugsnag::Api.get "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end

  describe ".last_response", :vcr do
    it "caches the last agent response" do
      Bugsnag::Api.reset!
      client = Bugsnag::Api.client
      expect(client.last_response).to be_nil

      client.get "/"
      expect(client.last_response.status).to eq(200)
    end
  end

  describe ".basic_authenticated?" do
    it "knows when basic auth is being used" do
      client = Bugsnag::Api::Client.new(:email => "example@example.com", :password => "123456")
      expect(client.basic_authenticated?).to be true
    end
  end

  describe ".token_authenticated?" do
    it "knows when token auth is being used" do
      client = Bugsnag::Api::Client.new(:auth_token => "example")
      expect(client.token_authenticated?).to be true
    end
  end

  context "error handling" do
    it "raises on 404" do
      stub_get('/booya').to_return(:status => 404)
      expect { Bugsnag::Api.get('/booya') }.to raise_error(Bugsnag::Api::NotFound)
    end

    it "raises on 500" do
      stub_get('/boom').to_return(:status => 500)
      expect { Bugsnag::Api.get('/boom') }.to raise_error(Bugsnag::Api::InternalServerError)
    end

    it "includes an error" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:error => "Comments must contain a message"}.to_json
      begin
        Bugsnag::Api.get('/boom')
      rescue Bugsnag::Api::UnprocessableEntity => e
        expect(e.message).to include("Error: Comments must contain a message")
      end
    end

    it "raises on unknown client errors" do
      stub_get('/user').to_return \
        :status => 418,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "I'm a teapot"}.to_json
      expect { Bugsnag::Api.get('/user') }.to raise_error(Bugsnag::Api::ClientError)
    end

    it "raises on unknown server errors" do
      stub_get('/user').to_return \
        :status => 509,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "Bandwidth exceeded"}.to_json
      expect { Bugsnag::Api.get('/user') }.to raise_error(Bugsnag::Api::ServerError)
    end
  end
end
