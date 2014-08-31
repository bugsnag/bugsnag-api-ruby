describe Bugsnag::Api do
  before do
    Bugsnag::Api.reset!
  end

  after do
    Bugsnag::Api.reset!
  end

  describe ".configure" do
    Bugsnag::Api::Configuration::KEYS.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Bugsnag::Api.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Bugsnag::Api.configuration.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

  describe ".configuration" do
    it "exposes the client's configuration" do
      expect(Bugsnag::Api.configuration).to eq(Bugsnag::Api.client.configuration)
    end
  end

  describe ".client" do
    it "creates a static Bugsnag::Api::Client" do
      expect(Bugsnag::Api.client).to be_kind_of(Bugsnag::Api::Client)
    end

    it "caches the static client" do
      expect(Bugsnag::Api.client).to be(Bugsnag::Api.client)
    end
  end

  describe ".reset" do
    it "should reset the static client" do
      client = Bugsnag::Api.client
      Bugsnag::Api.reset!
      expect(client).not_to eq(Bugsnag::Api.client)
    end
  end
end
