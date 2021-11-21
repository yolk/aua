module Aua::Agents::Chrome
  def self.extend?(agent)
    agent.products.include?("Safari") && agent.products.include?("Chrome")
  end

  def type
    :Browser
  end

  def name
    @name ||= begin
      return :Iron if products.include?("Iron")
      return :RockMelt if products.include?("RockMelt")
      :Chrome
    end
  end

  module Frame
    def self.extend?(agent)
      agent.products.include?("chromeframe")
    end

    def type
      :Browser
    end

    def name
      :Chromeframe
    end

    def version
      @version ||= version_of("chromeframe")
    end
  end
end
