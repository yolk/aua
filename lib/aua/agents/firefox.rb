module Aua::Agents::Firefox
  PATTERN =  /^(Firefox|(p|P)rism|SeaMonkey|Camino|Iceweasel|Thunderbird|Epiphany|Namoroka|Flock|Navigator|Netscape)/

  def self.extend?(agent)
    agent.products.find{|product| product =~ PATTERN}
  end

  def type
    :Browser
  end

  def name
    @name ||= begin
      if products.include?("Prism")  || products.include?("prism")
        products[products.index("prism")] = "Prism" if products.include?("prism")
        return :Prism
      end
      return :Camino if products.include?("Camino")
      return :SeaMonkey if products.include?("SeaMonkey")
      return :Iceweasel if products.include?("Iceweasel")
      return :Thunderbird if products.include?("Thunderbird")
      return :Epiphany if products.include?("Epiphany")
      return :Flock if products.include?("Flock")
      return :NetscapeNavigator if products.include?("Navigator") || products.include?("Netscape")
      if p = products.find{|product| product =~ /^Firefox-/}
        products[products.index(p)] = "Firefox"
      end
      :Firefox
    end
  end

  def version
    @version ||= begin
      return version_of("Namoroka") if products.include?("Namoroka")
      return version_of("Netscape") if products.include?("Netscape")
      return version_of("Navigator") if products.include?("Navigator")
      super
    end
  end
end