module Aua::OperatingSystems::Linux
  
  def self.extend?(agent)
    agent.platform_string == "X11" || agent.app_comments_string.match(PATTERN_LINUX)
  end
  
  PATTERN_LINUX = /(l|L)inux/
  
  def platform
    :X11
  end
  
  def os_name
    :Linux
  end
  
  def os_version
    @os_version ||= if app_comments_string =~ /OpenBSD/
      "OpenBSD" 
    elsif products.include?("Ubuntu")
      "Ubuntu"
    elsif products.include?("Red") && products.include?("Hat")
      "Red Hat"
    elsif products.include?("CentOS")
      "CentOS"
    elsif products.include?("Gentoo")
      "Gentoo"
    elsif products.include?("SUSE")
      "SUSE"
    elsif products.include?("Fedora")
      "Fedora"
    elsif app_comments_string =~ /FreeBSD/
      "FreeBSD"
    elsif raw =~ /SunOS/
      "Solaris"
    elsif raw =~ /Debian/
      "Debian"
    elsif raw =~ /Maemo/
      "Maemo"
    end
  end
end