$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dossier/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dossier"
  s.version     = Dossier::VERSION
  s.authors     = ["TMA IT", "Kickserv"]
  s.email       = ["developer@tma1.com"]
  s.summary     = "SQL based report generation."
  s.description = "Easy SQL based report generation with the ability to accept request parameters and render multiple formats."
  s.homepage    = "https://github.com/kickserv/dossier"
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + %w[MIT-LICENSE Rakefile README.md VERSION]
  s.test_files = Dir["spec/**/*"] - %w[spec/dummy/config/dossier.yml]
     
  s.add_dependency "activesupport"
  s.add_dependency "actionpack"
  s.add_dependency "actionmailer"
  s.add_dependency "railties"
  s.add_dependency "responders"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "capybara"
  s.add_development_dependency "simplecov"
end
