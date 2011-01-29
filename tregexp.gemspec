Gem::Specification.new do |gem|
  gem.name = "tregexp"
  gem.version = "0.1.0"
  gem.authors = [ "Ian Young" ]
  gem.email = [ "ian.greenleaf+github@gmail.com" ]

  gem.summary = "Readable Regexps"
  gem.description = <<-EOF
    TRegexp is a new syntax for regular expressions.
    Less compact, but human-readable. By regular humans.
  EOF

  gem.add_dependency "mocha"

  gem.files = Dir[ 'lib/**/*.rb', 'test/**/*' ]

end
