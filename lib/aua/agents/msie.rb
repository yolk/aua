module Aua::Agents::Msie

  def self.extend?(agent)
    agent.app_comments_string =~ PATTERN || agent.products[-1] == "Edge"
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
      if app_comments_string =~ PATTERN
        $1 == "Trident\/" ? TRIDENT_VERSION_MAP[$2] || $2 : $2
      else
        version_of("Edge").split(/\./, 2)[0]
      end
    end
  end
end