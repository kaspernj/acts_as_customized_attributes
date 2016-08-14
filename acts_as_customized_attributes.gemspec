# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_customized_attributes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_customized_attributes"
  s.version     = ActsAsCustomizedAttributes::VERSION
  s.authors     = ["Kasper Johansen"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "https://www.github.com/kaspernj/acts_as_customized_attributes"
  s.summary     = "Customized attributes for models."
  s.description = "Key-based custom attributes that can be created on the fly for ActiveRecord models."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4"

  s.add_development_dependency "rspec-rails", "3.3.3"
  s.add_development_dependency "factory_girl_rails", "4.5.0"
  s.add_development_dependency "forgery", "0.6.0"
  s.add_development_dependency "codeclimate-test-reporter", "0.4.8"
  s.add_development_dependency "sqlite3", "1.3.11"
  s.add_development_dependency "active-record-transactioner"
  s.add_development_dependency "best_practice_project", "0.0.10"
  s.add_development_dependency "rubocop", "0.42.0"
end
