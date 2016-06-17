$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bp_custom_fields/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bp_custom_fields"
  s.version     = BpCustomFields::VERSION
  s.authors     = ["Ben Polinsky"]
  s.email       = ["benjamin.polinsky@gmail.com"]
  s.homepage    = "https://github.com/benpolinsky/bp_custom_fields"
  s.summary     = "TODO: Summary of BpCustomFields."
  s.description = "TODO: Description of BpCustomFields."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2.6"
  s.add_dependency "jquery-rails"
  s.add_dependency "cocoon"
  s.add_dependency "carrierwave"
  s.add_dependency "mini_magick"
  s.add_dependency "ranked-model"
    
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "site_prism"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "launchy"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-activemodel-mocks"
end
