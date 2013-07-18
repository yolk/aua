module Aua::OperatingSystems::Mobiles
  def self.extend?(agent)
    agent.platform_string == "BlackBerry" ||
    agent.platform_string == "J2ME/MIDP" ||
    agent.app_comments_string =~ PATTERN_SYMBIAN
  end

  PATTERN_SYMBIAN = /Symb(ian)?\s?OS\/?([\d\.]+)?/

  def name
    @name ||= begin
      name = super
      return :OperaMobile if name == :Opera && platform == :SymbianOS
      name
    end
  end

  def platform
    @platform ||= begin
      return :SymbianOS if app_comments_string =~ PATTERN_SYMBIAN
      platform_string.to_sym
    end
  end

  def os_name
    @os_name ||= platform
  end

  def os_version
    @os_version ||= begin
      return $2 if app_comments_string =~ PATTERN_SYMBIAN
      nil
    end
  end
end