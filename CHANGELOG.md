Changelog
=========

## 3.0.1 (14 January 2025)

### Fixes

* Fix issue with update several errors at once
    | [#52](https://github.com/bugsnag/bugsnag-api-ruby/pull/52)

## 3.0.0 (3 November 2022)

### Enhancements

* Update required Sawyer version to `~> 0.9.2`
    | [ilvez](https://github.com/ilvez)
    | [#43](https://github.com/bugsnag/bugsnag-api-ruby/pull/43)

* Require Ruby 2.6+
    | [#44](https://github.com/bugsnag/bugsnag-api-ruby/pull/44)

## 2.1.1 (2 November 2021)

### Fixes

* Fix Faraday deprecation warning
    | [sambostock](https://github.com/sambostock)
    | [#36](https://github.com/bugsnag/bugsnag-api-ruby/pull/36)

## 2.1.0 (28 July 2021)

### Enhancements

* Add stability and release endpoints
    |  [#34](https://github.com/bugsnag/bugsnag-api-ruby/pull/34)

## 2.0.3 (11 May 2021)

### Fixes

* Fix error handling middleware compatibility with Faraday v1.2.0 and above
    | [askreet](https://github.com/askreet)
    | [#30](https://github.com/bugsnag/bugsnag-api-ruby/pull/30)

* Remove call to deprecated `URI.escape`
    | [askreet](https://github.com/askreet)
    | [#28](https://github.com/bugsnag/bugsnag-api-ruby/pull/28)

## 2.0.2 (21 Feb 2018)

### Fixes

* Fixes issue with custom query parameters being overridden
    | [#13](https://github.com/bugsnag/bugsnag-api-ruby/pull/13)

## 2.0.1 (15 Nov 2017)

### Fixes

* Adds `X-Bugsnag-Api` header so that on-prem clients may use this tool
    | [tremlab](https://github.com/tremlab)
    | [#14](https://github.com/bugsnag/bugsnag-api-ruby/pull/14)

## 2.0.0 (10 Oct 2017)

This release changes the gem to access v2 of the [Bugsnag data-access API](https://docs.bugsnag.com/api/data-access/), with full API documentation found [here](http://docs.bugsnagapiv2.apiary.io/).

### Enhancements

* Uses Bugsnag data-access API v2 endpoints with associated changes to endpoints and methods, namely:
    - Removes:
        * accounts
        * users
    - Adds:
        * organizations
        * collaborators
        * event fields
        * pivots
        * trends
    - Updates:
        * comments
        * errors
        * events
        * projects

  | [#11](https://github.com/bugsnag/bugsnag-api-ruby/pull/11)

* Adds error response to hitting rate limit
  | [#10](https://github.com/bugsnag/bugsnag-api-ruby/pull/10)

### Known Issues

* per_page option not respected in paginated API calls
* issues with event_fields not being created correctly

1.0.2
-----
-   Fix load-order bug when requiring from certain environments

1.0.1
-----
-   Added test suite
-   Fixed a few bugs

1.0.0
-----
-   Initial release
