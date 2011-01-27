module Aua::Agents::ApiClients
  KNOWN_CLIENTS = %w(curl Zendesk Python-urllib Ruby PEAR NativeHost Java AppEngine-Google Twisted)
  
  def self.extend?(agent)
    KNOWN_CLIENTS.include?(agent.app) ||
    agent.raw =~ /^Yahoo Pipes ([\d\.]+)$/ ||
    agent.app =~ /^Systemeinstellungen/ ||
    agent.app =~ /^SystemUIServer/
  end
  
  def type
    :ApiClient
  end
  
  def name
    @name ||= begin
      if raw =~ /^Yahoo Pipes ([\d\.]+)$/
        :YahooPipes
      elsif app == "PEAR"
        :PearPHP
      elsif app == "NativeHost"
        :CappucinosNativeHost
      elsif app =~ /^Systemeinstellungen/
        :SystemPreferences
      elsif app =~ /^SystemUIServer/
        :SystemUIServer
      elsif app == "Twisted"
        :PythonTwistedPageGetter
      else
        app.to_sym
      end
    end
  end
  
  def version
    @version ||= begin
      return $1 if raw =~ /^Yahoo Pipes ([\d\.]+)$/
      return comments.first[1] if name == :"AppEngine-Google" && comments.first[1]
      versions.first 
    end
  end
end