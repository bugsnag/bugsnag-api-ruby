# How to contribute

1. [Fork](https://help.github.com/articles/fork-a-repo) the [library on GitHub](https://github.com/bugsnag/bugsnag-api-ruby)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit and push until you are happy with your contribution
4. Push to the branch (`git push origin my-new-feature`)
5. Run the tests and make sure they all pass:

    ```
    rake spec
    ```

6. Create a [Pull Request](https://help.github.com/articles/using-pull-requests)

Thank you!

## How to release

If you're a member of the core team, follow these instructions for releasing bugsnag-api-ruby.

### First time setup

* Create a Rubygems account
* Get a member of the platforms team to add you as contributor on bugsnag-ruby in Rubygems

### Every time

* Update `CHANGELOG.md`
* Update the version number in [`lib/bugsnag/api/version.rb`](./lib/bugsnag/api/version.rb)
* Update `README.md` if necessary with changes to the interface or configuration
* Commit/push your changes
* Release to rubygems

  ```
  gem build bugsnag-api.gemspec
  gem push bugsnag-api-[version].gem
  ```
* Create a new GitHub release, copying the changes from the change log


