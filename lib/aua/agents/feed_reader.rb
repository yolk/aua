module Aua::Agents::FeedReader
  KNOWN_CLIENTS = %w(AppleSyndication Netvibes Windows-RSS-Platform Vienna NewsGatorOnline NewsFire NetNewsWire MWFeedParser SimplePie MagpieRSS Feedfetcher-Google Apple-PubSub)
  
  def self.extend?(agent)
    KNOWN_CLIENTS.include?(agent.app)
  end
  
  def type
    :FeedReader
  end
  
  def name
    app.to_sym
  end
  
  def version
    @version ||= versions.first 
  end
end