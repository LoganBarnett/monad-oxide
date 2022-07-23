require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name = 'monad-oxide'
  s.files = Dir['lib/**/*.rb'].reject {|f| f !~ /_spec\.rb$/ }
  s.version = MonadOxide::VERSION
  s.summary = "Ruby port of Rust's Result and Option."
  s.description = <<-EOD
Monad-Oxide is a port of Rust's built-in monads from std, such as Result and
Option. This enables better reasoning about error handling and possibly missing
data.
EOD
  s.licenses = ['Apache-2.0', 'MIT']
  # This make work on earlier versions, but it's hard to find a feature/version
  # matrix.
  s.required_ruby_version = '>= 2.7.0'
  # Used by yard to process org-mode (.org) documents.
  s.add_development_dependency 'org-ruby'
  # Used for building the gems.
  s.add_development_dependency 'rake'
  # Used to run the test suite.
  s.add_development_dependency 'rspec'
  # Used to generate and publish documentation to rdoc.
  s.add_development_dependency 'yard'
  s.authors = [
    'Logan Barnett',
  ]
end
