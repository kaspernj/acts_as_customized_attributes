#!/usr/bin/env rake
# frozen_string_literal: true
begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end
begin
  require "rdoc/task"
rescue LoadError
  require "rdoc/rdoc"
  require "rake/rdoctask"
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "ActsAsCustomizedAttributes"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.md")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

require "best_practice_project"
BestPracticeProject.load_tasks

Bundler::GemHelper.install_tasks
