Bugsnag API Toolkit for Ruby
============================
![Build status](https://travis-ci.org/bugsnag/bugsnag-api-ruby.svg?branch=master)

The library allows for quick read/write access to the [Bugsnag Data Access API](https://docs.bugsnag.com/api/data-access/) from your Ruby applications. You can use this library to build your own applications which leverage data found in your Bugsnag dashboard.

Version 2.x (current) of this gem corresponds to v2 of the Data Access API, while [1.x](https://github.com/bugsnag/bugsnag-api-ruby/tree/v1.0.3) uses the (deprecated) v1 of the Data Access API.

If you are looking to automatically detect crashes in your Ruby apps, you should take a look at the [Bugsnag Ruby Detection Library](https://docs.bugsnag.com/platforms/ruby) instead.

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
  - [Organizations](#organizations)
  - [Collaborators](#collaborators)
  - [Comments](#comments)
  - [Errors](#errors)
  - [Events](#events)
  - [Event Fields](#event-fields)
  - [Pivots](#pivots)
  - [Projects](#projects)
  - [Trends](#trends)
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

### Require gem

```ruby
require 'bugsnag/api'
```

### Making Requests

API methods are available as module methods or as client instance methods.

```ruby
# Provide authentication credentials
Bugsnag::Api.configure do |config|
  config.auth_token = "your-personal-auth-token"
end

# Access API methods
organizations = Bugsnag::Api.organizations
```

or...

```ruby
# Create an non-static API client
client = Bugsnag::Api::Client.new(auth_token: "your-personal-auth-token")

# Access API methods on the client
organizations = client.organizations
```

### Consuming Resources

Most methods return a [`Resource`](http://www.rubydoc.info/gems/sawyer/Sawyer/Resource)
object which provides dot notation and [] access for fields returned in the API
response.

```ruby
# Fetch an organization
org = Bugsnag::Api.organization("organization-id")

puts org.name
# => "Acme Co"

puts org.fields
# => #<Set: {:id, :name, :slug, :creator, :created_at, :updated_at, :auto_upgrade, :upgrade_url, :billing_emails}>

puts org.id
# => "50baed0d9bf39c1431000003"

account.rels[:upgrade].href
# => "https://api.bugsnag.com/organizations/50baed0d9bf39c1431000003/..."
```

### Accessing Related Resources

Resources returned by Bugsnag API methods contain not only data but hypermedia link relations:

```ruby
project = Bugsnag::Api.projects("organization-id")

# Get the users rel, returned from the API as users_url in the resource
project.rels[:errors].href
# => "https://api.bugsnag.com/projects/50baed0d9bf39c1431000003/errors"

errors = project.rels[:errors].get.data
errors.first.message
# => "Can't find method: getStrng()"
```

When processing API responses, all `*_url` attributes are culled in to the link relations collection. Any `url` attribute becomes `.rels[:self]`.


### Authentication

API usage requires authentication. You can authenticate using either your
Bugsnag account's [auth token](https://app.bugsnag.com/settings/my-account/)
or with your Bugsnag user credentials.

```ruby
# Authenticate with your Bugsnag account's auth token
Bugsnag::Api.configure do |config|
  config.auth_token = "your-personal-auth-token"
end

# Authenticate using your Bugsnag email address and password. Unavailable when
# using multi-factor authentication.
Bugsnag::Api.configure do |config|
  config.email = "example@example.com"
  config.password = "password"
end
```

### Pagination

Many Bugsnag API resources are paginated. While you may be tempted to start adding :page parameters to your calls, the API returns links to the next and previous pages for you in the `Link` response header, which we expose in `rels`:

```ruby
errors = Bugsnag::Api.errors("project-id", per_page: 100)
last_response = Bugsnag::Api.last_response
until last_response.rels[:next].nil?
  last_response = last_response.rels[:next].get
  errors.concat last_response.data
end
```

### Filtering

Events and Errors can be filtered to return a subset of data. Any of the filters usable in the Bugsnag dashoard can be used in this API. The filter object is a hash of Event Field keys containing an array of filter values. Each filter value has a `type` and a `value` to filter on. The type determines the type of comparison that will be performed.

| `type` | Description | Multiple value combination logic |
|-|-|-|
| `eq` | Filter for items that 'match' the value. Some fields require an exact match and some support substring matching. | OR |
| `ne` | Filter for items that don't match the value. | AND |

:warning: Note that the Event Field `search` can not be used more than once in a call.

You can see the filterable fields for a project using the following snippet, after setting the `project-id` value.

```ruby
fields = Bugsnag::Api.event_fields("project-id")

puts "List of the searchable fields for this project:"
fields.each_with_index do |field,idx|
  puts "  [#{idx}] #{field.display_id}"
end
# => List of the searchable fields for this project:
# =>   [0] event
# =>   [1] error
# =>   [2] search
# =>   [3] user.id
# => ...
```

### Accessing HTTP responses

While most methods return a `Resource` object or a `Boolean`, sometimes you may need access to the raw HTTP response headers. You can access the last HTTP response with `Client#last_response`:

```ruby
organization = Bugsnag::Api.organizations.first
response = Bugsnag::Api.last_response
status = response.headers[:status]
```

## API Methods

The following methods are available via `Bugsnag::Api` and the Client interface.
For more information, consult the [API
documentation](http://www.rubydoc.info/gems/bugsnag-api/Bugsnag/Api/Client)

### Organizations

```ruby
# List your organizations
orgs = Bugsnag::Api.organizations

# Get a single organization
org = Bugsnag::Api.organization("organization-id")
```

### Collaborators

```ruby
# List organization collaborators
users = Bugsnag::Api.collaborators("organization-id")

# List project collaborators
users = Bugsnag::Api.collaborators(nil, "project-id")

# Invite a user to an account
user = Bugsnag::Api.invite_collaborators("org-id", "example@example.com", {
  admin: true
})

# Update a user's account permissions
user = Bugsnag::Api.update_collaborator_permissions("org-id", "user-id", {
  admin: false
})

# Remove a user from an account
Bugsnag::Api.delete_collaborator("org-id", "user-id")
```


### Comments

```ruby
# List error comments
comments = Bugsnag::Api.comments("project-id", "error-id")

# Get a single comment
comment = Bugsnag::Api.comment("project-id", "comment-id")

# Create a comment
comment = Bugsnag::Api.create_comment("project-id", "error-id", "comment message")

# Update a comment
comment = Bugsnag::Api.update_comment("comment-id", "new comment message")

# Delete a comment
Bugsnag::Api.delete_comment("comment-id")
```

### Errors

```ruby
# List project errors
errors = Bugsnag::Api.errors("project-id", nil)

# List errors with a filter (see Filtering section for more information)
# Returns errors that match `EXC_BAD_INSTRUCTION`, this could be from the error class, message, context, or stack trace.
errors = Bugsnag::Api.errors("project-id", nil, direction:"desc", filters: {
  "search": [{ "type":"eq", "value":"EXC_BAD_INSTRUCTION" }]
})

# Get a single error
error = Bugsnag::Api.error("project-id", "error-id")

# Update a single error
error = Bugsnag::Api.update_errors("project-id", "error-id")

# Update bulk errors
error = Bugsnag::Api.update_errors("project-id",
                                   ["error-id1", "error-id2"])

# Delete an error
error = Bugsnag::Api.delete_error("project-id", "error-id")
```

### Events

```ruby
# List project events
events = Bugsnag::Api.events("project-id")

# List error events
events = Bugsnag::Api.error_events("project-id", "error-id")

# List error events with a filter (see Filtering section for more information)
# Returns events with
#   class `EXC_BAD_INSTRUCTION` OR `EXC_BAD_ACCESS`
#   AND where the device is jailbroken
events = Bugsnag::Api.events(PROJECT_ID, direction:"desc", filters: {
  "event.class": [{ "type":"eq", "value":"EXC_BAD_INSTRUCTION" }, { "type":"eq", "value":"EXC_BAD_ACCESS"  }],
  "device.jailbroken": [{ "type":"eq", "value":"false"}]
})

# Get the latest event
event = Bugsnag::Api.latest_event("project-id", "error-id")

# Get a single event
event = Bugsnag::Api.event("project-id", "event-id")

# Delete an event
Bugsnag::Api.delete_event("project-id", "event-id")
```

### Event Fields

```ruby
# list a project's event fields
Bugsnag::Api.event_fields("project-id")

# create an event field
Bugsnag::Api.create_event_field("project-id", "display id", "path.to.field", {})

# update an event field
Bugsnag::Api.update_event_field("project-id", "display id", "new.path.to.field")

# delete an event field
Bugsnag::Api.delete_event_field("project-id", "display id")
```

### Projects

```ruby
# List organization projects
projects = Bugsnag::Api.projects("organization-id")

# Get a single project
project = Bugsnag::Api.project("project-id")

# Create a project
project = Bugsnag::Api.create_project("organization-id", "project name", "rails")

# Update a project
project = Bugsnag::Api.update_project("project-id", {
  name: "New Name"
})

# Regenerate a project API key
Bugsnag::Api.regenerate_api_key("project-id")

# Delete a project
Bugsnag::Api.delete_project("project-id")
```

### Pivots

```ruby
# list a project's pivots
Bugsnag::Api.pivots("project-id")

# list pivot values
Bugsnag::Api.pivot_values("project-id", "display id")
```

### Trends

```ruby
# list an error's trends in 5 buckets
Bugsnag::Api.trends_buckets("project-id", 5, "error-id")

# list a project's trends by resolution
Bugsnag::Api.trends_resolution("project-id", "2h")
```

## Advanced Configuration

### Endpoint

By default, `https://api.bugsnag.com` is used for API access, if you are using
Bugsnag Enterprise, you can configure a custom endpoint.

```ruby
Bugsnag::Api.configure do |config|
  config.endpoint = "http://api.bugsnag.example.com"
end
```

### Proxy

If you are using a proxy, you can configure the API client to use it.

```ruby
Bugsnag::Api.configure do |config|
  config.proxy = {
    uri:        "http://proxy.example.com",
    user:       "foo",
    password:   "bar"
  }
end
```


## License

The Bugsnag API Toolkit for Ruby is free software released under the MIT License. See [LICENSE.txt](LICENSE.txt) for details.
