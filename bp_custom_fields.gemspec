$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bp_custom_fields/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bp_custom_fields"
  s.version     = BpCustomFields::VERSION
  s.authors     = ["Ben Polinsky"]
  s.email       = ["benjamin.polinsky@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of BpCustomFields."
  s.description = "TODO: Description of BpCustomFields."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
  s.add_dependency "jquery-rails"
  s.add_dependency "cocoon"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec-rails"
end
