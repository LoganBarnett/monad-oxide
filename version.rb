#!/usr/bin/env ruby

def version_get()
  File.read('lib/version.rb')
    .match(/VERSION\s*=\s*'(\d+)\.(\d+)\.(\d+)'/)[2]
end

if $0 == __FILE__
  puts(version_get())
end
