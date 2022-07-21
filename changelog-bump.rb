#!/usr/bin/env ruby
##
# A CLI script for bumping the changelog automatically.
#
# The script marks the "Upcoming" section as the new version, and creates a new
# Upcoming section.
##

require_relative './version'
version = version_get().to_i
warn("Found version #{version.inspect}.")
file = File.read('CHANGELOG.org')
replaced = file.sub(
  /^\*\* (Upcoming)(.+?)\n\*\* 0\.#{version}\.0/sm,
  "** Upcoming
** v0.#{version + 1}.0\\2
** v0.#{version}.0",
)
if file == replaced
  warn "Error: No changes to made CHANGELOG.org."
  exit 1
else
  #File.write('CHANGELOG.org', replaced)
  puts replaced
  warn("CHANGELOG.org updated!")
end
