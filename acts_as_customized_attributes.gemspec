$:.push File.expand_path("../lib", __FILE__)

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

  s.add_dependency "rails", "~> 3.1.12"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "forgery"
  s.add_development_dependency "codeclimate-test-reporter"

  s.add_development_dependency "mysql2"
end
