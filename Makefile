
all:
	rake spec

build:
	gem build tennis.gemspec

irb:
	irb -Ilib -rtennis

# to push to rubygems
push:
	gem push tennis-0.1.1.gem
