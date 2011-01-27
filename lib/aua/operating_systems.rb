require 'aua/stack_base'

class Aua
  module OperatingSystems
    extend StackBase
    extend self
     
    def default
      [Mobiles, Windows, Mac, Android, Linux, IOS, Palm]
    end
  end
end

Dir["#{File.dirname(__FILE__)}/operating_systems/*.rb"].each do |os|
  require(os)
end