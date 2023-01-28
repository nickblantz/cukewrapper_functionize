# CukewrapperFunctionize

This plugin allows you to execute Functionize tests

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cukewrapper'

group :cukewrapper_plugins do
  gem 'cukewrapper_functionize'
  # ...
end
```

## Usage

### Feature File

Add the `@cw.fnze.tid` tag to your scenario

```gherkin
@cw.fnze.tid=113fba21-f125-4327-13ge-77c0af834b76
Scenario: My scenario
    Given ...
```

### Configuration File
You can provide the following below in `cukewrapper.yml`

```yaml
functionize:
  project: '0000000'
```

### Environment Variables

<!-- - `FUNCTIONIZE_ENV`: Overrides the environment in `cukewrapper.yml` -->
- `FUNCTIONIZE_USERNAME`: Sets the username for authenticating to Functionize tests
- `FUNCTIONIZE_PASSWORD`: Sets the password for authenticating to Functionize tests

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nickblantz/cukewrapper_functionize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nickblantz/cukewrapper_functionize/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CukewrapperFunctionize project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nickblantz/cukewrapper_functionize/blob/master/CODE_OF_CONDUCT.md).
