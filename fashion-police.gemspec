# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "fashion-police"
  s.version = "0.0.1"
  s.authors = ["Giles Bowkett"]
  s.email = ["gilesb@gmail.com"]
  s.homepage = ""
  s.summary = %q{Enforce Idiomatic.js via pre-commit hook.}
  s.description = %q{Style guide all the things.}
  s.license = "MIT"
  s.rubyforge_project = "fashion-police"

  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.files.reject! { |filename| filename.include? ".git" }
  s.files.reject! { |filename| filename.include? "Gemfile" }

  s.test_files = Dir['spec/**/*']
  s.executables = 'fashion-police'
  s.require_paths = ["lib"]

  s.add_development_dependency('rspec')
  s.add_runtime_dependency('rainbow')

  s.post_install_message = "
  =====================================================================
  To enforce JS code style:
    rm $(git rev-parse --git-dir)/hooks/pre-commit.sample
    echo 'fashion-police' > $(git rev-parse --git-dir)/hooks/pre-commit
    chmod 0755 $(git rev-parse --git-dir)/hooks/pre-commit
  =====================================================================

"
end

