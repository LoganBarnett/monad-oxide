#!/usr/bin/env ruby
##
# Get the version in lib/version.rb.
# @return [String] the version String that VERSION is set to.
def version_get()
  File.read('lib/monad-oxide/version.rb')
    .match(/VERSION\s*=\s*'(\d+)\.(\d+)\.(\d+)'/)[2]
end

##
# Set the version in lib/version.rb.
# @param version [String] The total version (sans 'v') to set.
def version_set(version)
  File.write(
    'lib/monad-oxide/version.rb',
    File
      .read('lib/monad-oxide/version.rb')
      .sub(
        /VERSION\s*=\s*'(\d+)\.(\d+)\.(\d+)'/, "VERSION='#{version}'",
      ),
  )
end

if $0 == __FILE__
  puts(version_get())
end
