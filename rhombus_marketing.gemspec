$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rhombus_marketing/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rhombus_marketing"
  s.version     = RhombusMarketing::VERSION
  s.authors     = ["Sumit Birla"]
  s.email       = ["sbirla@tampahost.net"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RhombusMarketing."
  s.description = "TODO: Description of RhombusMarketing."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.4"

  s.add_development_dependency "sqlite3"
end
