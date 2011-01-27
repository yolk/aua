module Aua::Agents::SearchBot
  PATTERN_BING = /bingbot\/([\d\.]+)/
  PATTERN_BAIDU = /Baiduspider\/?([\d\.]+)?/
  PATTERN_GOOGLE = /Googlebot(-Mobile)?\/?([\d\.]+)?/
  
  def self.extend?(agent)
    agent.raw =~ PATTERN_BING ||
    agent.app_comments[1] == "Yahoo! Slurp" ||
    agent.raw =~ PATTERN_BAIDU ||
    agent.raw =~ PATTERN_GOOGLE ||
    agent.app == "msnbot"
  end
  
  def type
    :SearchBot
  end
  
  def name
    @name ||= begin
      return :Bingbot if raw =~ PATTERN_BING
      return :YahooSlurp if app_comments[1] == "Yahoo! Slurp"
      return :Baiduspider if raw =~ PATTERN_BAIDU
      return $1 ? :GooglebotMobile : :Googlebot if raw =~ PATTERN_GOOGLE
      app.to_sym
    end
  end
  
  def version
    @version ||= begin
      return $1 if raw =~ PATTERN_BING
      return $1  if raw =~ PATTERN_BAIDU
      return $2  if raw =~ PATTERN_GOOGLE
      super 
    end
  end
end