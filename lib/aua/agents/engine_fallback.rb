module Aua::Agents::EngineFallback
  def self.extend?(agent)
    agent.app == "Mozilla" &&
    (agent.products.include?("AppleWebKit") ||
    agent.products.include?("Gecko"))
  end
  
  def type
    :Browser
  end
  
  def name
    @name ||= begin
      return :AppleWebKit if products.include?("AppleWebKit")
      return :Gecko if products.include?("Gecko")
      nil
    end
  end
end