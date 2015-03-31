
# NOTE: this needs to be changed in lib/tennis/version.rb at the same time!
VERSION=0.4.0

all:
	bundle exec rake spec

build:
	bundle exec gem build tennis.gemspec

irb:
	bundle exec irb -Ilib -rtennis

# to push to rubygems
push:
	bundle exec gem push tennis-$(VERSION).gem
