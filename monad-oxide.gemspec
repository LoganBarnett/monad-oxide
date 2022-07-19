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
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.authors = [
    'Logan Barnett',
  ]
end
