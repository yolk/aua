require 'aua/stack_base'

class Aua
  module Agents
    extend StackBase
    extend self

    def default
      @default ||= [HttpChecker, ApiClients, FeedReader, Firefox, Chrome::Frame, Chrome, Safari, Opera, Msie, SearchBot, Konqueror, Others, EngineFallback, OtherBrowsers]
    end
  end
end

Dir["#{File.dirname(__FILE__)}/agents/*.rb"].each do |agent|
  require(agent)
end