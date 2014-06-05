module Aua::Agents::FeedReader
  KNOWN_CLIENTS = %w(FreeRSSReader FeeddlerRSS FeeddlerPro hawkReader Fever Superfeedr Feedly FeedlyApp Reeder AppleSyndication Netvibes Windows-RSS-Platform Vienna NewsGatorOnline NewsFire NetNewsWire MWFeedParser SimplePie MagpieRSS Feedfetcher-Google Apple-PubSub Feedbin FeedDemon)

  def self.extend?(agent)
    KNOWN_CLIENTS.include?(agent.app) ||
    (agent.app == "Tumblr" && agent.products.include?("RSS") && agent.products.include?("syndication"))
  end

  def type
    :FeedReader
  end

  def name
    return :TumblrRSSSyndication if app == "Tumblr"
    app.to_sym
  end

  def version
    @version ||= versions[0] || versions[1]
  end
end