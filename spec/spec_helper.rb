require 'rspec'
require File.dirname(__FILE__) + '/../lib/aua.rb'

if File.exist?(File.dirname(__FILE__) + '/../../aua-mite/')
  $LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../aua-mite/lib')
  require "aua-mite"
  puts "Loaded mite extension"
end