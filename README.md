# rspec-doom

A standalone RSpec file watcher with Doom-themed notifications. Runs tests
automatically and shows Doom Guy images based on test results.

Built on [Cruise](https://github.com/marcoroth/cruise), a fast OS-native file
watcher — no Guard required.

> **Read more:** [Still way beyond cool: resurrecting the Doomguy TDD loop](https://amalrik.github.io/posts/still-way-beyond-cool-doomguy-tdd-loop/) — the story behind this gem, and the 2007 post that started it all.

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
bundle exec rspec-doom --notify-file n   # write notifications to a file (headless/CI)
```

Press Ctrl-C to stop.

## Doom Images

The gem includes 5 Doom-themed images (via Notiffany desktop notifications):

- `doom1.png` — All tests passing
- `doom2.png` — 1-2 failures
- `doom3.png` — 3-5 failures
- `doom4.png` — 6-10 failures
- `doom5.png` — 11+ failures

The images are Doom HUD sprites from id Software, included here as a fan and
educational homage to the classic *autotest + growl + Doomguy* setup. DOOM and
its sprites are trademarks of id Software or their respective owners; this
project is not affiliated with or endorsed by id Software.

## Development

```bash
bundle install
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the MIT License.