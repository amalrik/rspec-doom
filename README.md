# rspec-doom

A standalone RSpec file watcher with Doom-themed notifications. Runs tests
automatically and shows Doom Guy images based on test results.

Built on [Cruise](https://github.com/marcoroth/cruise), a fast OS-native file
watcher — no Guard required.

## Installation

Add to your Gemfile:

```ruby
gem 'rspec-doom'
```

Then:

```bash
bundle install
```

Requires Ruby 3.2+ and macOS or Linux (precompiled native gems).

## Usage

From the root of your project:

```bash
bundle exec rspec-doom
```

Watches `app/` and `spec/` by default. When a spec changes it runs that spec;
when a source file changes it runs the matching spec (or the whole suite if
no matching spec exists).

### Options

```bash
bundle exec rspec-doom lib spec          # watch extra directories
bundle exec rspec-doom --cmd 'rspec'     # custom RSpec command
bundle exec rspec-doom --debounce 0.5    # debounce in seconds
```

Press Ctrl-C to stop.

## Doom Images

The gem includes 5 Doom-themed images (via Notiffany desktop notifications):

- `doom1.png` — All tests passing
- `doom2.png` — 1-2 failures
- `doom3.png` — 3-5 failures
- `doom4.png` — 6-10 failures
- `doom5.png` — 11+ failures

## Development

```bash
bundle install
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the MIT License.