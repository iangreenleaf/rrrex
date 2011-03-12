require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end


task :default => ["test"]

spec = Gem::Specification.new do |s|

  s.name = "rrrex"
  s.version = "0.1.0"
  s.author = "Ian Young"
  s.email = "ian.greenleaf+github@gmail.com"

  s.summary = "Really Readable Regexps"
  s.description = <<-EOF
    Rrrex is a new syntax for regular expressions.
    Less compact, but human-readable. By regular humans.
  EOF

  s.files = Dir[ 'lib/**/*.rb', 'test/**/*', '[A-Z]*' ]

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.md)
  s.rdoc_options      = %w(--main README.md)

  s.add_development_dependency("mocha")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

task :package => :gemspec

Rake::RDocTask.new do |rd|
  rd.main = "README.md"
  rd.rdoc_files.include("README.md", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
