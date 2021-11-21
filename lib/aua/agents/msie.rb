module Aua::Agents::Msie

  def self.extend?(agent)
    agent.app_comments_string =~ PATTERN
  end

  PATTERN = /(MSIE |Trident\/)([\d.]+)/
  TRIDENT_VERSION_MAP = {
    "4.0" => "8.0",
    "5.0" => "9.0",
    "6.0" => "10.0",
    "7.0" => "11.0"
  }

  def type
    :Browser
  end

  def name
    :MSIE
  end

  def version
    @version ||= if app_comments_string =~ PATTERN
      $1 == "Trident\/" ? TRIDENT_VERSION_MAP[$2] || $2 : $2
    end
  end
end
