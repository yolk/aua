require 'rspec'
require 'rspec/its'
require File.dirname(__FILE__) + '/../lib/aua.rb'

if File.exist?(File.dirname(__FILE__) + '/../../aua-mite/')
  $LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../aua-mite/lib')
  require "aua-mite"
  puts "Loaded mite extension"
end

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
