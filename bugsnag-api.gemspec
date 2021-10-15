# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bugsnag/api/version'

Gem::Specification.new do |spec|
  spec.name          = "bugsnag-api"
  spec.version       = Bugsnag::Api::VERSION
  spec.authors       = ["James Smith"]
  spec.email         = ["james@bugsnag.com"]
  spec.description   = %q{Bugsnag API toolkit for ruby}
  spec.summary       = %q{Bugsnag API toolkit for ruby}
  spec.homepage      = "https://github.com/bugsnag/bugsnag-api-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  if RUBY_VERSION < "2.2.0"
    spec.add_dependency "sawyer", '0.8.1'

    spec.add_development_dependency "rake", "< 12.0.0"
    spec.add_development_dependency "rubocop", "0.41.2"
    spec.add_development_dependency "faker", "1.3.0"

    # i18n is used by faker
    spec.add_development_dependency "i18n", "< 1.0.0"

    # crack is used by webmock
    spec.add_development_dependency "crack", "< 0.4.5"
  else
    spec.add_dependency "sawyer", '~> 0.8.1'

    spec.add_development_dependency "rake"
    spec.add_development_dependency "rubocop", "~> 0.52.1"
    spec.add_development_dependency "faker", "> 1.7.3"
  end

  if RUBY_VERSION < "2.0.0"
    spec.add_development_dependency "webmock", "2.3.2"
    spec.add_development_dependency "addressable", "2.3.6"

    # hashdiff is used by webmock
    spec.add_development_dependency "hashdiff", "< 0.3.8"

    # parser is used by rubocop
    spec.add_development_dependency "parser", "< 2.5.0"
  else
    spec.add_development_dependency "webmock", "> 2.3.2"
    spec.add_development_dependency "addressable", "> 2.3.6"
  end

  if RUBY_VERSION < "2.0.0"
    spec.add_development_dependency "json", "< 2.0.0"
  elsif RUBY_VERSION < "2.3.0"
    spec.add_development_dependency "json", "< 2.6.0"
  else
    spec.add_development_dependency "json"
  end

  # public_suffix is used by addressable & sawyer
  if RUBY_VERSION < "2.0.0"
    spec.add_development_dependency "public_suffix", "< 1.5.0"
  elsif RUBY_VERSION < "2.1.0"
    spec.add_development_dependency "public_suffix", "< 3.0.0"
  end

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 2.9"
end
