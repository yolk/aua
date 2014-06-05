module Aua::OperatingSystems::Mac

  def self.extend?(agent)
    agent.platform_string == "Macintosh" ||
    agent.os_string && agent.os_string =~ PATTERN_MACOS ||
    agent.products.include?("Darwin")
  end

  PATTERN_OSX   = /Mac OS X\s?([\d\._]+)?/
  PATTERN_MACOS = /Mac_PowerPC/
  DAWRWIN_2_OSX = {
    '1.0.2' => 'DP2',
    '1.1' => 'DP4',
    '1.2.1' => 'Public Beta',
    '1.3.1' => '10.0',
    '1.4.1' => '10.1',
    '6.0.1' => '10.2',
    '6.0.2' => '10.2',
    '7.0'   => '10.3',
    '8.0'   => '10.4',
    '9.0'   => '10.5',
    '9.1.0' => '10.5.1',
    '9.2.0' => '10.5.2',
    '9.3.0' => '10.5.3',
    '9.4.0' => '10.5.4',
    '9.5.0' => '10.5.5',
    '9.6.0' => '10.5.6',
    '9.7.0' => '10.5.7',
    '9.8.0' => '10.5.8',
    '10.0'   => '10.6',
    '10.0.0' => '10.6',
    '10.1.0' => '10.6.1',
    '10.2.0' => '10.6.2',
    '10.3.0' => '10.6.3',
    '10.4.0' => '10.6.4',
    '10.4.1' => '10.6.4',
    '10.5.0' => '10.6.5',
    '10.6.0' => '10.6.6',
    '10.7.0' => '10.6.7',
    '10.8.0' => '10.6.8',

    '11.0' => '10.7',
    '11.0.0' => '10.7',
    '11.4.2' => '10.7.5',

    '12.0' => '10.8',
    '12.0.0' => '10.8',
    '12.5' => '10.8.5',
    '12.5.0' => '10.8.5',

    '13.0' => '10.9',
    '13.0.0' => '10.9.0'
  }

  def platform
    darwin? && !DAWRWIN_2_OSX[version_of(:Darwin)] ? :Darwin : :Macintosh
  end

  def os_name
    @os_name ||= if osx?
      :MacOSX
    elsif darwin?
      DAWRWIN_2_OSX[version_of(:Darwin)] ? :MacOSX : :Darwin
    elsif macos?
      :MacOS
    end
  end

  def os_version
    @os_version ||= if m = osx?
      m[1] ? m[1].gsub(/_/, ".") : nil
    elsif darwin?
      DAWRWIN_2_OSX[version_of(:Darwin)] || version_of(:Darwin)
    end
  end

  private

  def osx?
    app_comments_string.match PATTERN_OSX
  end

  def macos?
    app_comments_string.match PATTERN_MACOS
  end

  def darwin?
    products.include?("Darwin")
  end
end