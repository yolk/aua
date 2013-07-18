module Aua::OperatingSystems::Android

  def self.extend?(agent)
    agent.platform_string == "Linux" && agent.comments.first && agent.comments.first[2] && agent.comments.first[2].match(PATTERN)
  end

  PATTERN = /^Android\s([\d\.]+)$/

  def platform
    @platform ||= :Android
  end

  def os_name
    @os_name ||= :Android
  end

  def os_version
    @os_version ||= comments.first[2] =~ PATTERN && $1
  end

  def name
    @name ||= :AndroidWebkit
  end

  def version
    @version ||= version_of("Version")
  end
end