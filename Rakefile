require 'rubygems'
require 'rake'
require 'rake/clean'

CLEAN.include %w[
  'mydatabase.db'
]

desc "Run the app"
task :run do
  sh "rackup config.ru"
end

namespace :deps do
  desc "Run Bundler to install dependencies"
  task :install do
    sh "bundle install --without production"
  end

  desc "Run Bundler to update dependencies"
  task :update do
    sh "bundle update"
  end
end

task :default => :run
