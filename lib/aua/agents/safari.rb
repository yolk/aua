module Aua::Agents::Safari
  def self.extend?(agent)
    agent.products[-1] == "Safari" ||
    agent.products[0] == "Safari" ||
    (agent.products == ["Mozilla", "AppleWebKit", "Mobile"] && Aua::OperatingSystems::IOS::PLATFORMS.include?(agent.platform_string)) ||
    agent.products.include?("OmniWeb") ||
    agent.products[0] == "MobileSafari"
  end

  BUILDS = {
    '85' => '1.0',
    '85.5'=>'1.0',
    '85.7'=>'1.0.2',
    '85.8'=>'1.0.3',
    '85.8.1'=>'1.0.3',
    '100'=>'1.1',
    '100.1'=>'1.1.1',
    '125.7'=>'1.2.2',
    '125.8'=>'1.2.2',
    '125.9'=>'1.2.3',
    '125.11'=>'1.2.4',
    '125.12'=>'1.2.4',
    '312'=>'1.3',
    '312.3'=>'1.3.1',
    '312.3.1'=>'1.3.1',
    '312.5'=>'1.3.2',
    '312.6'=>'1.3.2',
    '412'=>'2.0',
    '412.2'=>'2.0',
    '412.2.2'=>'2.0',
    '412.5'=>'2.0.1',
    '416.12'=>'2.0.2',
    '416.13'=>'2.0.2',
    '417.8'=>'2.0.3',
    '417.9.2'=>'2.0.3',
    '417.9.3'=>'2.0.3',
    '419.3'=>'2.0.4',
    '419' => '2.0.4',
    '425.13' => '2.2'
  }

  def type
    :Browser
  end

  def name
    @name ||= begin
      return :MobileSafari if products.include?("Mobile") || products[0] == "MobileSafari"
      return :Fluid if products.include?("Fluid")
      return :OmniWeb if products.include?("OmniWeb")
      :Safari
    end
  end

  def version
    @version ||= begin
      case name
      when :Fluid, :OmniWeb
        version_of(name)
      else
        version_of("Version") || BUILDS[version_of("Safari")] ||
        version_of("Mobile") || version_of("MobileSafari") || version_of("Safari")
      end
    end
  end
end