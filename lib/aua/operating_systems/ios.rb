module Aua::OperatingSystems::IOS
  PLATFORMS = %w(iPhone iPad iPod)
  PATTERN = /CPU( iPhone)?( OS )?([\d\._]+)? like Mac OS X/

  def self.extend?(agent)
    PLATFORMS.include?(agent.platform_string) && agent.os_string =~ PATTERN
  end

  def platform
    platform_string.to_sym
  end

  def os_name
    :iOS
  end

  def os_version
    os_string =~ PATTERN && $3 && $3.gsub(/_/, ".")
  end
end