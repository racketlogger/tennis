
all:
	rake spec

build:
	gem build tennis.gemspec

# to push to rubygems
#	gem push tennis-0.1.1.gem
