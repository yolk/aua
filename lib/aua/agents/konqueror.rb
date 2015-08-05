module Aua::Agents::Konqueror
  def self.extend?(agent)
    agent.products.include?("KHTML") &&
    (agent.app_comments[1] =~ PATTERN ||
    agent.products.include?("Konqueror"))
  end

  PATTERN = /Konqueror\/([\d\.]+)/

  def type
    :Browser
  end

  def name
    @name ||= :Konqueror
  end

  def version
    @version ||= app_comments[1] =~ PATTERN && $1 || version_of("Konqueror")
  end
end