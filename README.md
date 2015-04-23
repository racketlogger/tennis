# Tennis

[![Gem Version](https://badge.fury.io/rb/tennis.svg)](http://badge.fury.io/rb/tennis) [![Build Status](https://travis-ci.org/racketlogger/tennis.svg)](https://travis-ci.org/racketlogger/tennis) [![Code Climate](https://codeclimate.com/github/racketlogger/tennis/badges/gpa.svg)](https://codeclimate.com/github/racketlogger/tennis) [![Test Coverage](https://codeclimate.com/github/racketlogger/tennis/badges/coverage.svg)](https://codeclimate.com/github/racketlogger/tennis)

Ruby gem with utilities to manage, print and validate tennis scores


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tennis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tennis

## Usage

The gem assumes a score can be two or three sets (5 sets is partially supported, however it has bugs and it's not well tested).

The gem does a little processing on the input for some spacing, etc.

There are two players: **0 (home player) and 1 (away player)**

Results refer to players 0 and 1 and are typically indexed for players 0 and 1. If a result has an array, it will typically have something (e.g. games won) for player 0 in index 0 and for player 1 in index 1.

```ruby
irb> sc = Tennis.new("7-6,  4-6 , 6 - 2")
=> #<Tennis:....>
irb> sc.winner
=> 0            # this means the winner is the first player, a.k.a. player 0 or "home player"
irb> sc.sets_won
=> [2, 1]       # two sets one by player 0, one set by player 1
irb> sc.sets_lost
=> [1, 2]
irb> sc.games_won
=> [17, 14]
irb> score.games_lost
=> [14, 17]
irb> sc.to_s
=> "7-6, 4-6, 6-2"    # cleanly formatted score, as a string
irb> sc.flipped
=> "6-7, 6-4, 2-6"    # "flipped" score, from player 1's perspective
irb> sc.score         # score as an array of sets (each an array with player 0 and 1 scores)
=> [[7, 6], [4, 6], [6, 2]]
irb> sc.default?      # was this score a default?
=> false
```

### Defaults

The library supports a form of arbitrary (callers-epcific) defaults: any score starting with a `p` is considered a default, for example:

 * p0-win-<reason> means player 0 won, e.g. p0-win-by-forfeit
 * p1-win-<reason> means player 1 won, e.g. p1-win-by-retirement

```ruby
irb> sc = Tennis.new("p1-win-injured")
=> #<Tennis:....>
irb> sc.winner
=> 1
irb> sc.sets_won
=> [0, 2]
irb> sc.games_won
=> [0, 12]
irb> sc.score
=> "Default"
irb> sc.to_s
=> "Default"
irb> sc.flipped
=> "Default"
irb> sc.default?
=> true
```

## Contributing

1. Fork it ( https://github.com/racketlogger/tennis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
