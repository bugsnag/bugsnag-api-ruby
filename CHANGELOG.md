Changelog
=========

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
