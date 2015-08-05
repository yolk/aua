module Aua::OperatingSystems::Windows

  def self.extend?(agent)
    agent.comments.first &&
    (agent.app_comments.include?("Windows") ||
    agent.comments_string =~ PATTERN)
  end

  VERSIONS = {
    "10.0"    => "10",
    "NT 10.0" => "10",
    "NT 6.3"  => "8.1",
    "NT 6.2"  => "8",
    "NT 6.1"  => "7",
    "NT 6.0"  => "Vista",
    "NT 5.2"  => "XP",
    "NT 5.1"  => "XP",
    "NT 5.01" => "2000",
    "NT 5.0"  => "2000",
    "NT 4.0"  => "NT 4.0",
    "98"      => "98",
    "95"      => "95",
    "CE"      => "CE",
    "9x 4.90" => "ME"
  }

  PATTERN = /Win(dows)?(\sPhone)?\s?([\d\sA-Zx\.]+)/
  PHONE_PATTERN = /Windows Phone/

  def platform
    :Windows
  end

  def os_name
    @os_name ||= windows_phone? ? :WindowsPhone : :Windows
  end

  def os_version
    @os_version ||= comments_string =~ PATTERN && VERSIONS[$3] || $3
  end

  private

  def windows_phone?
    !!(comments_string =~ PHONE_PATTERN)
  end
end