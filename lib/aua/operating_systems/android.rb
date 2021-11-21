module Aua::OperatingSystems::Android

  def self.extend?(agent)
    agent.platform_string == "Linux" && agent.comments.first && agent.comments.first.any?{|c| c.match(PATTERN) }
  end

  PATTERN = /^Android\s([\d\.]+)$/

  def platform
    @platform ||= :Android
  end

  def os_name
    @os_name ||= :Android
  end

  def os_version
    @os_version ||= comments.first.any?{|c| c.match(PATTERN) } && $1
  end

  def name
    @name ||= super || :AndroidWebkit
  end

  def version
    @version ||= super || version_of("Version")
  end
end
