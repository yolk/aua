module Aua::OperatingSystems::Palm
  #{ }"Mozilla/5.0 (webOS/1.3; U; en-US) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/1.0 Safari/525.27.1 Desktop/1.0"
  
  def self.extend?(agent)
    agent.platform_string =~ PATTERN && agent.products.include?("Safari")
  end
  
  PATTERN = /^webOS\/([\d\.]+)$/
  
  def platform
    @platform ||= :webOS
  end
  
  def os_name
    @os_name ||= :webOS
  end
  
  def os_version
    @os_version ||= platform_string =~ PATTERN && $1
  end
  
  def type
    :Browser
  end
  
  def name
    @name ||= :webOSWebkit
  end
  
  def version
    @version ||= version_of("Version") 
  end
end