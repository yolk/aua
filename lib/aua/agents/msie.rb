module Aua::Agents::Msie
  
  def self.extend?(agent)
    agent.app_comments_string =~ PATTERN
  end
  
  PATTERN = /MSIE ([\d.]+)/
  
  def type
    :Browser
  end
  
  def name
    :MSIE
  end
  
  def version
    @version ||= begin
      app_comments_string =~ PATTERN
      $1
    end
  end
end