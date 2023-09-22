#!/usr/bin/env ruby

require_relative './changelog-bump'
require_relative './version'
version = "0.#{version_get().to_i + 1}.0"
puts "Creating and pushing tag '#{version}'."
version_set(version)
puts `bundle install`
# Gemfile.lock is also bumped after this, and needs to be added or it will foul
# up later releases.
puts `git add CHANGELOG.org lib/version.rb Gemfile.lock`
puts `git commit -m "v#{version}"`
# TODO: -a is unsigned (annotated) tagging, use signed tagging.
puts `git tag "v#{version}"`
puts `git push --follow-tags`
# Push normal commits too?
puts `git push`
