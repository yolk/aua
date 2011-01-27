module Aua::Agents::HttpChecker
  KNOWN_CLIENTS = %w(check_http NewRelicPinger W3C_Validator FeedValidator)
  
  def self.extend?(agent)
    agent.app &&
    (KNOWN_CLIENTS.include?(agent.app) ||
    agent.app =~ /Pingdom\.com_bot_version_/)
  end
  
  def type
    :HttpChecker
  end
  
  def name
    @name ||= begin
      return :PingdomBot if app =~ /Pingdom\.com_bot_version_([\d\.]+)/
      return :Nagios if app == "check_http"
      app.to_sym
    end
  end
  
  def version
    @version ||= begin
      return $1 if app =~ /Pingdom\.com_bot_version_([\d\.]+)/
      versions.first 
    end
  end
end