# Stateful

![Build Status](https://travis-ci.org/nulldef/stateful.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/nulldef/stateful/badge.svg?branch=master)](https://coveralls.io/github/nulldef/stateful?branch=master)

 Finite state machine for your objects 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stateful'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stateful

## Usage

### Basic usage
Stateful provides a DSL for defining state machine for your class

```ruby
class Car
  include Stateful
  
  attr_accessor :state
  
  stateful :state, initial: :idle do
    state :idle
    state :riding
    
    event :ride, idle: :riding
  end
end
```

Then `Car` object will receive following methods:
```ruby
car = Car.new
car.idle? # => true
car.riding? # => false
car.ride! # changes idle state to riding
```

### Hooks
You can be able to execute some procs before and after event will be fired

```ruby
class Car
  include Stateful
  
  attr_accessor :state, :started
  
  stateful :state, initial: :idle do
    state :idle
    state :riding
    
    event :ride, idle: :riding,
                 before: -> { self.started = true },
                 after: :stop_engine
  end
  
  def stop_engine
    self.started = false
  end
end
```

And then before state changes will be executed `before` proc, and after
changing - `after` proc (in instance context).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stateful.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
