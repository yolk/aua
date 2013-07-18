module Aua::Agents::ApiClients
  KNOWN_CLIENTS = %w(facebookexternalhit Wget curl Zend_Http_Client Zendesk Python-httplib2 Python-urllib Ruby PEAR HTTP_Request2 NativeHost Java AppEngine-Google Twisted)

  def self.extend?(agent)
    KNOWN_CLIENTS.include?(agent.app) ||
    agent.raw =~ PATTERN_YAHOO_PIPES ||
    agent.app =~ PATTERN_GERMAN_SYSTEM_PREFS ||
    agent.app =~ PATTERN_SYSTEM_UI_SEVER
  end

  PATTERN_YAHOO_PIPES         = /^Yahoo Pipes ([\d\.]+)$/
  PATTERN_GERMAN_SYSTEM_PREFS = /^Systemeinstellungen/
  PATTERN_SYSTEM_UI_SEVER     = /^SystemUIServer/

  def type
    :ApiClient
  end

  def name
    @name ||= begin
      if raw =~ PATTERN_YAHOO_PIPES
        :YahooPipes
      elsif app == "PEAR" || app == "HTTP_Request2"
        :PearPHPHttpRequest
      elsif app == "NativeHost"
        :CappucinosNativeHost
      elsif app =~ PATTERN_GERMAN_SYSTEM_PREFS
        :SystemPreferences
      elsif app =~ PATTERN_SYSTEM_UI_SEVER
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