# DeepState

[![Tests](https://app.codeship.com/projects/79963640-48fa-0137-7372-027095d735c1/status?branch=master)](https://app.codeship.com/projects/79963640-48fa-0137-7372-027095d735c1/status?branch=master) [![Maintainability](https://api.codeclimate.com/v1/badges/521f9df0f0b22032156b/maintainability)](https://codeclimate.com/github/ideasasylum/deepstate/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/521f9df0f0b22032156b/test_coverage)](https://codeclimate.com/github/ideasasylum/deepstate/test_coverage) [![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=ideasasylum/deepstate)](https://dependabot.com)

A Ruby gem for implementing state charts (state machines with nested states), conditional and delayed transition.

---

<!-- MarkdownTOC -->

- [Why use DeepState?](#why-use-deepstate)
- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [States](#states)
  - [Nested States](#nested-states)
  - [Current States](#current-states)
- [Transitions](#transitions)
- [Hooks](#hooks)
- [Rails integration](#rails-integration)
- [Visualising a State Chart using XState](#visualising-a-state-chart-using-xstate)
- [Development](#development)
  - [Internal Patterns](#internal-patterns)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

<!-- /MarkdownTOC -->

---

<a id="why-use-deepstate"></a>
## Why use DeepState?

There are already plenty of great Ruby gems for modelling state machines. Maybe you should use one of them:

[AASM](https://github.com/aasm/aasm) is a old favourite with a lot of functionality

[Workflow](https://github.com/geekq/workflow/) is my go-to solution for simple state machines in Rails with a nice DSL and 

[Finite Machine](https://github.com/piotrmurach/finite_machine) is a nice library that separates the machine itself from the ActiveRecord model.

**DeepState** uses some of the best features from those libraries but with the added super-power of hierarchical states. Specifically, [State Charts](https://statecharts.github.io/). 

Have you ever used multiple state machines to model a system?

Or, wanted to make a transition conditional?

Or, needed to delay a transition?

Or, modelled a pseudo-state as being in A, B, or C states?

Yeah? Well read on because DeepState and state charts might be just what you need. 

The main features are:

- Nested/hierarchical states (state charts)
- Multiple "current" states
- Entry/exit hooks
- Conditional transitions (coming soon)
- Delayed transitions (coming soon)
- Rails-integration

<a id="installation"></a>
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deepstate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deepstate

<a id="basic-usage"></a>
## Basic Usage

Coming soon!

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">So what am I doing with my week’s vacation? I’m knee-deep in Ruby implementing a State Charts gem for fun<br><br>More info on State Charts: <a href="https://t.co/Y9q9a7DWNJ">https://t.co/Y9q9a7DWNJ</a> <br><br>It’s currently looks like this… <a href="https://t.co/LL0gHbuOIE">pic.twitter.com/LL0gHbuOIE</a></p>&mdash; Jamie Lawrence (@ideasasylum) <a href="https://twitter.com/ideasasylum/status/1121069679022419968?ref_src=twsrc%5Etfw">April 24, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<a id="states"></a>
## States

<a id="nested-states"></a>
### Nested States

<a id="current-states"></a>
### Current States

<a id="transitions"></a>
## Transitions

TBD

<a id="hooks"></a>
## Hooks

TBD

<a id="rails-integration"></a>
## Rails integration

<a id="visualising-a-state-chart-using-xstate"></a>
## Visualising a State Chart using XState

TBD

<a id="development"></a>
## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

<a id="internal-patterns"></a>
### Internal Patterns

DeepState uses the visitor pattern to build up information from the `StateDefinition` structure. A visitor object that responds to `visit` can be passed to `StateDefinition#visit` and that object's `visit` method will be invoked for every state as a depth-first search through the hierarchy. This can be used to collect information (like `MachineVisitor`) or generate an export (like `XStateVisitor`)

<a id="contributing"></a>
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ideasasylum/deepstate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

<a id="license"></a>
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

<a id="code-of-conduct"></a>
## Code of Conduct

Everyone interacting in the Statelychart project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ideasasylum/deepstate/blob/master/CODE_OF_CONDUCT.md).
