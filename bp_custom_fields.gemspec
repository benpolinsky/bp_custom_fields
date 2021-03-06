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
  s.summary     = "Custom Fields for Rails"
  s.description = "End-users need love in the Ruby on Rails community.  
  There are a few promising CMSs around, but in general they feel heavy handed.
  Many of these solutions include some sort of custom field functionality, 
  but none touch the expansiveness and flexibility that Wordpress' Advanced Custom Fields plugin does.
  Enter BpCustomFields.  More to come soon.
  "
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
  s.add_development_dependency "selenium-webdriver", "2.53.4"
  s.add_development_dependency "poltergeist"
  s.add_development_dependency "site_prism"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "launchy"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-activemodel-mocks"
end
