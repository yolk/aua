module Aua::Agents::OtherBrowsers
  KNOWN_CLIENTS = %w(Raven)
  
  def self.extend?(agent)
    KNOWN_CLIENTS.include?(agent.app)
  end
  
  def type
    :Browser
  end
  
  def name
    products[0].to_sym
  end
end