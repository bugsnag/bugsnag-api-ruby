Bugsnag API Toolkit for Ruby
============================

The library allows for quick read/write access to the [Bugsnag API](https://bugsnag.com/docs/api) from your Ruby applications. You can use this library to build your own applications which leverage data found in your Bugsnag dashboard.

If you are looking to automatically detect crashes in your Ruby apps, you should take a look at the [Bugsnag Ruby Detection Library](https://bugsnag.com/docs/notifiers/ruby) instead.

This library borrows heavily from the code and philosophies of the fantastic [Octokit](https://github.com/octokit/octokit.rb) library. A big thanks to [@pengwynn](https://github.com/pengwynn) and the rest of the Octokit team!


## Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Making Requests](#making-requests)
  - [Consuming Resources](#consuming-resources)
  - [Accessing Related Resources](#accessing-related-resources)
  - [Authentication](#authentication)
  - [Pagination](#pagination)
  - [Accessing HTTP responses](#accessing-http-responses)
- [API Methods](#api-methods)
  - [Accounts](#accounts)
  - [Comments](#comments)
  - [Errors](#errors)
  - [Events](#events)
  - [Projects](#projects)
  - [Users](#users)
- [Advanced Configuration](#advanced-configuration)


## Installation

Add this line to your application's Gemfile:

```ruby
gem "bugsnag-api"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install bugsnag-api
```


## Usage

### Making Requests

API methods are available as module methods or as client instance methods.

```ruby
# Provide authentication credentials
Bugsnag::Api.configure do |config|
  config.auth_token = "your-account-api-token"
end

# Fetch the current account
account = Bugsnag::Api.account
```

or...

```ruby
# Create an non-static API client
client = Bugsnag::Api::Client.new(auth_token: "your-account-api-token")

# Access API methods on the client
accounts = client.accounts
```

### Consuming Resources

Most methods return a `Resource` object which provides dot notation and [] access for fields returned in the API response.

```ruby
# Fetch the current account
account = Bugsnag::Api.account

puts account.name
# => "Acme Co"

puts account.fields
# => #<Set: {:id, :name, :created_at, :updated_at, :url, :users_url, :projects_url, :account_creator, :billing_contact}>

puts account[:id]
# => "50baed0d9bf39c1431000003"

account.rels[:users].href
# => "https://api.bugsnag.com/accounts/50baed0d9bf39c1431000003/users"
```

**Note:** URL fields are culled into a separate `.rels` collection to make [accessing related resources](#accessing-related-resources) much simpler.


### Accessing Related Resources

Resources returned by Bugsnag API methods contain not only data but hypermedia link relations:

```ruby
account = Bugsnag::Api.account

# Get the users rel, returned from the API as users_url in the resource
account.rels[:users].href
# => "https://api.bugsnag.com/accounts/50baed0d9bf39c1431000003/users"

users = account.rels[:users].get.data
users.last.name
# => "James Smith"
```

When processing API responses, all `*_url` attributes are culled in to the link relations collection. Any `url` attribute becomes .rels[:self].


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

### Pagination

Many Bugsnag API resources are paginated. While you may be tempted to start adding :page parameters to your calls, the API returns links to the next and previous pages for you in the `Link` response header, which we expose in `rels`:

```ruby
errors = Bugsnag::Api.errors("project-id", per_page: 100)
errors.concat Bugsnag::Api.last_response.rels[:next].get.data
```


### Accessing HTTP responses

While most methods return a `Resource` object or a `Boolean`, sometimes you may need access to the raw HTTP response headers. You can access the last HTTP response with `Client#last_response`:

```ruby
account   = Bugsnag::Api.account
response  = Bugsnag::Api.last_response
status    = response.headers[:status]
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


## Advanced Configuration

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


## Build Status

![Build status](https://travis-ci.org/bugsnag/bugsnag-api-ruby.svg?branch=master)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

The Bugsnag API Toolkit for Ruby is free software released under the MIT License. See [LICENSE.txt](LICENSE.txt) for details.
