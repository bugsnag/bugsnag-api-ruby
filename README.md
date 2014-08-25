Bugsnag API Ruby Toolkit
========================

The library allows for quick read-write access to the [Bugsnag API](https://bugsnag.com/docs/api) from Ruby applications. Use this library if you want to build your own applications which leverage data found in your Bugsnag dashboard. If you are looking to automatically detect crashes in your Ruby apps, you should take a look at the [Bugsnag Ruby Detection Library](https://bugsnag.com/docs/notifiers/ruby) instead.

This library shares code and philosophies with the fantastic [Octokit](https://github.com/octokit/octokit.rb) library.


## Installation

Add this line to your application's Gemfile:

    gem "bugsnag-api"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bugsnag-api


## Usage

```ruby
# Create a Bugsnag API client
client = Bugsnag::Api::Client.new(:api_token => "your-api-token")

# Get information about the authenticated account
account = client.account

# Get a list of users on the account, by following the users hyperlink
users = client.last_response.rels[:users].get.data
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
