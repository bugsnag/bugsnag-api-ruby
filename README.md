Bugsnag API Toolkit for Ruby
============================

The library allows for quick read/write access to the [Bugsnag API](https://bugsnag.com/docs/api) from your Ruby applications. You can use this library to build your own applications which leverage data found in your Bugsnag dashboard.

If you are looking to automatically detect crashes in your Ruby apps, you should take a look at the [Bugsnag Ruby Detection Library](https://bugsnag.com/docs/notifiers/ruby) instead.

This library shares code and philosophies with the fantastic [Octokit](https://github.com/octokit/octokit.rb) library.


## Contents

- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [API Methods](#api-methods)
  - [Accounts](#accounts)
  - [Comments](#comments)
  - [Errors](#errors)
  - [Events](#events)
  - [Projects](#projects)
  - [Users](#users)


## Installation

Add this line to your application's Gemfile:

    gem "bugsnag-api"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bugsnag-api


## Usage

### Basic Usage (Static client)

```ruby
# Configure the static API client
Bugsnag::Api.configure do |config|
  config.auth_token = "your-account-api-token"
end

# Access API methods directly on `Bugsnag::Api`
account = Bugsnag::Api.account
```

### Non-static Client

```ruby
# Create a new API client, configured using a block
client = Bugsnag::Api::Client.new do |config|
  config.auth_token = "your-account-api-token"
end

# Create a new API client, configured using params
client = Bugsnag::Api::Client.new({
  auth_token: "your-account-api-token"
})

# Re-configure an existing API client
client.configure do |config|
  config.auth_token = "another-api-token"
end

# Access API methods on the client
client.accounts
```


## Configuration

### Authentication

API usage requires authentication. You can authenticate using either your
Bugsnag account's [auth token](https://bugsnag.com/docs/api#account-authentication)
or with your Bugsnag user's email address and password.

```ruby
# Authenticate with your Bugsnag account's auth token
Bugsnag::Api.configure do |config|
  config.auth_token = "your-account-api-token"
end

# Authenticate using your Bugsnag email address and password
Bugsnag::Api.configure do |config|
  config.email = "example@example.com"
  config.password = "password"
end
```

### Endpoint

By default, `https://api.bugsnag.com` is used for API access, if you are using
Bugsnag Enterprise, you can configure a custom endpoint.

```ruby
Bugsnag.Api.configure do |config|
  config.endpoint = "http://api.bugsnag.example.com"
end
```

### Proxy

If you are using a proxy, you can configure the API client to use it.

```ruby
Bugsnag.Api.configure do |config|
  config.proxy = {
    uri:        "http://proxy.example.com",
    user:       "foo",
    password:   "bar"
  }
end
```


## API Methods

### Account

```ruby
# List your accounts
accounts = Bugsnag::Api.accounts

# Get a single account
account = Bugsnag::Api.account("account-id")

# Get authenticated account (requires account auth)
account = Bugsnag::Api.account
```

### Comments

```ruby
# List error comments
comments = Bugsnag::Api.comments("error-id")

# Get a single comment
comment = Bugsnag::Api.comment("comment-id")

# Create a comment
comment = Bugsnag::Api.create_comment("error-id", "comment message")

# Update a comment
comment = Bugsnag::Api.update_comment("comment-id", "new comment message")

# Delete a comment
Bugsnag::Api.delete_comment("comment-id")
```

### Errors

```ruby
# List project errors
errors = Bugsnag::Api.errors("project-id")

# Get a single error
error = Bugsnag::Api.error("error-id")

# Resolve an error
error = Bugsnag::Api.resolve_error("error-id")

# Re-open an error
error = Bugsnag::Api.reopen_error("error-id")

# Update an error
error = Bugsnag::Api.update_error("error-id", {
  resolved: true
})

# Delete an error
error = Bugsnag::Api.delete_error("error-id")
```

### Events

```ruby
# List project events
events = Bugsnag::Api.events("project-id")

# List error events
events = Bugsnag::Api.error_events("error-id")

# Get a single event
event = Bugsnag::Api.event("event-id")

# Delete an event
Bugsnag::Api.delete_event("event-id")
```

### Projects

```ruby
# List account projects
projects = Bugsnag::Api.projects("account-id")

# List authenticated account's projects (requires account auth)
projects = Bugsnag::Api.projects

# List user projects
projects = Bugsnag::Api.user_projects("user-id")

# Get a single project
project = Bugsnag::Api.project("project-id")

# Create a project
project = Bugsnag::Api.create_project("account-id", {
  name: "Name",
  type: "rails"
})

# Update a project
project = Bugsnag::Api.update_project("project-id", {
  name: "New Name"
})

# Delete a project
Bugsnag::Api.delete_project("project-id")
```

### Users

```ruby
# List account users
users = Bugsnag::Api.users("account-id")

# List authenticated account's users (requires account auth)
users = Bugsnag::Api.users

# List project users
users = Bugsnag::Api.project_users("project-id")

# Get a single user
user = Bugsnag::Api.user("user-id")

# Get authenticated user (requires user auth)
user = Bugsnag::Api.user

# Invite a user to an account
user = Bugsnag::Api.invite_user("account-id", "example@example.com", {
  admin: true
})

# Update a user's account permissions
user = Bugsnag::Api.update_user_permissions("account-id", "user-id", {
  admin: false
})

# Remove a user from an account
Bugsnag::Api.remove_user("account-id", "user-id")
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
