# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rrrex}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian Young"]
  s.date = %q{2011-03-11}
  s.description = %q{    Rrrex is a new syntax for regular expressions.
    Less compact, but human-readable. By regular humans.
}
  s.email = %q{ian.greenleaf+github@gmail.com}
  s.extra_rdoc_files = ["README.md"]
  s.files = ["lib/rrrex.rb", "lib/rrrex/match_data.rb", "lib/rrrex/or_match.rb", "lib/rrrex/single_atom_match.rb", "lib/rrrex/regexp.rb", "lib/rrrex/dsl_context.rb", "lib/rrrex/match.rb", "lib/rrrex/not_match.rb", "lib/rrrex/group_match.rb", "lib/rrrex/number_match.rb", "lib/rrrex/core_ext.rb", "lib/rrrex/range_match.rb", "lib/rrrex/unescaped_string_match.rb", "lib/rrrex/string_match.rb", "lib/rrrex/core_ext/string.rb", "lib/rrrex/core_ext/fixnum.rb", "lib/rrrex/core_ext/range.rb", "lib/rrrex/composite_match.rb", "lib/rrrex/concat_match.rb", "lib/method_missing_conversion.rb", "test/match_test.rb", "LICENSE", "Rakefile", "README.md"]
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Really Readable Regexps}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
