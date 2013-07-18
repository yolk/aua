module Aua::OperatingSystems::Windows

  def self.extend?(agent)
    agent.comments.first &&
    (agent.app_comments.include?("Windows") ||
    agent.comments_string =~ PATTERN)
  end

  VERSIONS = {
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

  PATTERN = /Win(dows)?\s?([\d\sA-Zx\.]+)/

  def platform
    :Windows
  end

  def os_name
    :Windows
  end

  def os_version
    @os_version ||= comments_string =~ PATTERN && VERSIONS[$2] || $2
  end
end