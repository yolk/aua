module Aua::Agents::Opera
  def self.extend?(agent)
    agent.products.include?("Opera")
  end

  PATTERN = /Opera ([\d.]+)/
  PATTERN_MINI = /Opera Mini\/([\d.]+)/
  PATTERN_MOBILE = /Opera Mobi\//

  def type
    :Browser
  end

  def name
    @name ||= begin
      return :OperaMobile if app_comments_string =~ PATTERN_MOBILE
      return :OperaMini if app_comments_string =~ PATTERN_MINI
      :Opera
    end
  end

  def version
    @version ||= begin
      return $1 if app_comments[1] =~ PATTERN_MINI
      (raw =~ PATTERN && $1) || version_of("Version") || version_of("Opera")
    end
  end
end