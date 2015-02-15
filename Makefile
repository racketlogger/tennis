
VERSION=0.1.7

all:
	rake spec

build:
	gem build tennis.gemspec

irb:
	irb -Ilib -rtennis

# to push to rubygems
push:
	gem push tennis-$(VERSION).gem
