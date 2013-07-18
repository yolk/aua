module Aua::Agents::Msie

  def self.extend?(agent)
    agent.app_comments_string =~ PATTERN
  end

  PATTERN = /(MSIE |Trident\/)([\d.]+)/
  TRIDENT_VERSION_MAP = {
    "7.0" => "11.0"
  }

  def type
    :Browser
  end

  def name
    :MSIE
  end

  def version
    @version ||= begin
      app_comments_string =~ PATTERN
      $1 == "Trident\/" ? TRIDENT_VERSION_MAP[$2] || $2 : $2
    end
  end
end