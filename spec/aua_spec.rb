require 'spec_helper'

describe Aua do

  describe ".parse/.new" do
    it "should be fast" do
      start = Time.now
      runs = 10
      runs.times do
        EXAMPLES.each do |string, values|
          Aua.parse string
        end
      end
      sec = Time.now - start
      mspr = ((sec/runs*1_000/EXAMPLES.size)*10_000).to_i/10_000.0
      puts "#{sec} sec #{mspr} ms/string #{(EXAMPLES.size*runs/sec).to_i} strings/sec"
      mspr.should < 0.2
    end unless ENV["TRAVIS"]

    context "when parsing blank string" do
      let(:user_agent) { Aua.parse("") }

      it "returns an instance of Aua" do
        user_agent.should be_kind_of(Aua)
      end
    end

    context "when parsing nil" do
      let(:user_agent) { Aua.parse(nil) }

      it "returns an instance of Aua" do
        user_agent.should be_kind_of(Aua)
      end
    end

    context "when parsing unknown string" do
      let(:user_agent) { Aua.parse("Bla/1.2.3;Blupp;X/2.0.0") }

      it "returns an instance of Aua" do
        user_agent.should be_kind_of(Aua)
      end
    end

    EXAMPLES = {
      # Firefox
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:22.0) Gecko/20100101 Firefox/22.0" =>
        { :type => :Browser, :name => :Firefox, :version => "22.0", :major_version => "22.0", :os_name => :MacOSX, :os_version => "10.8", :os_major_version => "10.8", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.13", :major_version => "3.6", :os_name => :MacOSX, :os_version => "10.6", :os_major_version => "10.6", :platform => :Macintosh },
      "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.11) Gecko/20101012 Firefox/3.6.11 " =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.11", :major_version => "3.6", :os_name => :Windows, :os_version => "Vista", :os_major_version => "Vista", :platform => :Windows },
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.2) Gecko/20100316 Firefox/3.6.2" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.2", :major_version => "3.6", :os_name => :Windows, :os_version => "7", :os_major_version => "7", :platform => :Windows },
      "Mozilla/5.0 (Windows; U; Windows NT 6.0; de; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13 (.NET CLR 3.5.30729)" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.13", :major_version => "3.6", :os_name => :Windows, :os_version => "Vista", :platform => :Windows },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9) Gecko/2008061004 Firefox/3.0" =>
        { :type => :Browser, :name => :Firefox, :version => "3.0", :major_version => "3.0", :os_name => :MacOSX, :os_version => "10.6", :platform => :Macintosh },
      "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.13", :major_version => "3.6", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; en-US; rv:1.9.0.3) Gecko/2008092414 Firefox/3.0.3" =>
        { :type => :Browser, :name => :Firefox, :version => "3.0.3", :major_version => "3.0", :os_name => :MacOSX, :os_version => "10.5", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0b9) Gecko/20100101 Firefox/4.0b9" =>
        { :type => :Browser, :name => :Firefox, :version => "4.0b9", :major_version => "4.0b", :os_name => :MacOSX, :os_version => "10.6", :platform => :Macintosh },
      "Mozilla/5.0 (Windows; U; Win 9x 4.90; en-US; rv:1.8.0.3) Gecko/20060426 Firefox/1.5.0.3" =>
        { :type => :Browser, :name => :Firefox, :version => "1.5.0.3", :major_version => "1.5", :os_name => :Windows, :os_version => "ME", :platform => :Windows },
      "Mozilla/5.0 (Windows; U; Win98; de-DE; rv:1.7) Gecko/20040803 Firefox/0.9.3" =>
        { :type => :Browser, :name => :Firefox, :version => "0.9.3", :major_version => "0.9", :os_name => :Windows, :os_version => "98", :platform => :Windows },
      "Mozilla/5.0 (X11; U; OpenBSD i386; en-US; rv:1.8.1.7) Gecko/20070930 Firefox/2.0.0.7" =>
        { :type => :Browser, :name => :Firefox, :version => "2.0.0.7", :major_version => "2.0", :os_name => :Linux, :os_version => "OpenBSD", :os_major_version => "OpenBSD", :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.13) Gecko/20101206 Ubuntu/10.04 (lucid) Firefox/3.6.13 (.NET CLR 3.5.30729)" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.13", :major_version => "3.6", :os_name => :Linux, :os_version => "Ubuntu", :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.13) Gecko/20101206 Red Hat/3.6-2.el5 Firefox/3.6.13" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.13", :major_version => "3.6", :os_name => :Linux, :os_version => "Red Hat", :os_major_version => "Red Hat", :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux x86_64; es-ES; rv:1.9.0.12) Gecko/2009072711 CentOS/3.0.12-1.el5.centos Firefox/3.0.12" =>
        { :type => :Browser, :name => :Firefox, :version => "3.0.12", :major_version => "3.0", :os_name => :Linux, :os_version => "CentOS", :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100915 Gentoo Firefox/3.6.9"  =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.9", :major_version => "3.6", :os_name => :Linux, :os_version => "Gentoo", :platform => :X11 },
      "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.13) Gecko/20101203 YFF35 Firefox/3.6.13 GTB7.1 (.NET CLR 3.5.30729)" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.13", :major_version => "3.6", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.13) Gecko/20101203 SUSE/3.6.13-0.2.1 Firefox/3.6.13" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.13", :major_version => "3.6", :os_name => :Linux, :os_version => "SUSE", :platform => :X11 },
      "Mozilla/5.0 (X11; Linux x86_64; rv:2.0b10pre) Gecko/20110120 Firefox-4.0/4.0b10pre" =>
        { :type => :Browser, :name => :Firefox, :version => "4.0b10pre", :major_version => "4.0b", :os_name => :Linux, :os_version => nil, :os_major_version => nil, :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.14pre) Gecko/20110113 Ubuntu/9.10 (karmic) Namoroka/3.6.14pre" =>
        { :type => :Browser, :name => :Firefox, :version => "3.6.14pre", :major_version => "3.6", :os_name => :Linux, :os_version => "Ubuntu", :platform => :X11 },

      # Firefox/Mozilla based
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9a9pre) Gecko/2007110108 prism/0.8" =>
        { :type => :Browser, :name => :Prism, :version => "0.8", :major_version => "0.8", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2pre) Gecko/20100322 Prism/1.0b4" =>
        { :type => :Browser, :name => :Prism, :version => "1.0b4", :major_version => "1.0b", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.15) Gecko/20101027 SeaMonkey/2.0.10" =>
        { :type => :Browser, :name => :SeaMonkey, :version => "2.0.10", :major_version => "2.0", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en; rv:1.9.0.19) Gecko/2010111021 Camino/2.0.6 (like Firefox/3.0.19)" =>
        { :type => :Browser, :name => :Camino, :version => "2.0.6", :os_name => :MacOSX, :os_version => "10.5", :platform => :Macintosh },
      "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110107 Iceweasel/3.5.16 (like Firefox/3.5.16)" =>
        { :type => :Browser, :name => :Iceweasel, :version => "3.5.16", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.0.19) Gecko/2010120923 Iceweasel/3.0.6 (Debian-3.0.6-3)" =>
        { :type => :Browser, :name => :Iceweasel, :version => "3.0.6", :os_name => :Linux, :os_version => "Debian", :platform => :X11 },
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7" =>
        { :type => :Browser, :name => :Thunderbird, :version => "3.1.7", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/5.0 (X11; U; Linux x86_64; en; rv:1.9.0.8) Gecko/20080528 Fedora/2.24.3-4.fc10 Epiphany/2.22 Firefox/3.0" =>
        { :type => :Browser, :name => :Epiphany, :version => "2.22", :major_version => "2.22", :os_name => :Linux, :os_version => "Fedora", :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux x86_64; en; rv:1.8.1.13) Gecko/20080326 (Debian-1.8.1.13-1) Epiphany/2.20" =>
        { :type => :Browser, :name => :Epiphany, :version => "2.20", :os_name => :Linux, :os_version => "Debian", :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008100716 Firefox/3.0.3 Flock/2.0" =>
        { :type => :Browser, :name => :Flock, :version => "2.0", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 Firefox/2.0.0.12 Navigator/9.0.0.6" =>
        { :type => :Browser, :name => :NetscapeNavigator, :version => "9.0.0.6", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.7.5) Gecko/20050519 Netscape/8.0.1" =>
        { :type => :Browser, :name => :NetscapeNavigator, :version => "8.0.1", :os_name => :Windows, :os_version => "2000", :platform => :Windows },

      # Safari
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1" =>
        { :type => :Browser, :name => :Safari, :version => "6.0.5", :os_name => :MacOSX, :os_version => "10.8.4", :os_major_version => "10.8", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; de-de) AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5" =>
        { :type => :Browser, :name => :Safari, :version => "5.0.2", :os_name => :MacOSX, :os_version => "10.5.8", :os_major_version => "10.5", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-us) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4" =>
        { :type => :Browser, :name => :Safari, :version => "5.0.3", :os_name => :MacOSX, :os_version => "10.6.6", :os_major_version => "10.6", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-de) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10" =>
        { :type => :Browser, :name => :Safari, :version => "4.0.4", :os_name => :MacOSX, :os_version => "10.6.2", :platform => :Macintosh },
      "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10" =>
        { :type => :Browser, :name => :Safari, :version => "4.0.4", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_7; en-us) AppleWebKit/525.28.3 (KHTML, like Gecko) Version/3.2.3 Safari/525.28.3" =>
        { :type => :Browser, :name => :Safari, :version => "3.2.3", :os_name => :MacOSX, :os_version => "10.5.7", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3" =>
        { :type => :Browser, :name => :Safari, :version => "2.0.4", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/412 (KHTML, like Gecko) Safari/412" =>
        { :type => :Browser, :name => :Safari, :version => "2.0", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/312.9 (KHTML, like Gecko) Safari/312.6" =>
        { :type => :Browser, :name => :Safari, :version => "1.3.2", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; es) AppleWebKit/85 (KHTML, like Gecko) Safari/85" =>
        { :type => :Browser, :name => :Safari, :version => "1.0", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Safari/6533.19.4 CFNetwork/454.11.5 Darwin/10.6.0 (i386) (iMac8%2C1)" =>
        { :type => :Browser, :name => :Safari, :version => "6533.19.4", :major_version => "6533.19", :os_name => :MacOSX, :os_version => "10.6.6", :platform => :Macintosh },

      # Safari based
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/600.5.17 (KHTML, like Gecko) FluidApp Version/2156 Safari/600.5.17" =>
        { :type => :Browser, :name => :Fluid, :version => "2156", :os_name => :MacOSX, :os_version => "10.10.3", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; de-de) AppleWebKit/533.18.1 (KHTML, like Gecko) Fluid/0.9.6 Safari/533.18.1" =>
        { :type => :Browser, :name => :Fluid, :version => "0.9.6", :os_name => :MacOSX, :os_version => "10.5.8", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_8; de-de) AppleWebKit/533.17.8 (KHTML, like Gecko) Fluid/0.9.6 Safari/533.17.8" =>
        { :type => :Browser, :name => :Fluid, :version => "0.9.6", :os_name => :MacOSX, :os_version => "10.5.8", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US) AppleWebKit/525.18 (KHTML, like Gecko, Safari/525.20) OmniWeb/v622.4.0.109283" =>
        { :type => :Browser, :name => :OmniWeb, :version => "v622.4.0.109283", :major_version => "v622.4.0.109283", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "MobileSafari/6531.22.7 CFNetwork/485.2 Darwin/10.3.1" =>
        { :type => :Browser, :name => :MobileSafari, :version => "6531.22.7", :os_name => :Darwin, :os_version => "10.3.1", :platform => :Darwin },
      "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Epiphany/2.30.6 Safari/534.7" =>
        { :type => :Browser, :name => :Epiphany, :version => "2.30.6", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Mozilla/5.0 (X11; U; OpenBSD arm; en-us) AppleWebKit/531.2+ (KHTML, like Gecko) Safari/531.2+ Epiphany/2.30.0" =>
        { :type => :Browser, :name => :Epiphany, :version => "2.30.0", :os_name => :Linux, :os_version => "OpenBSD", :platform => :X11 },
      "Mozilla/5.0 (X11; U; Linux x86_64; zh-cn) AppleWebKit/531.2+ (KHTML, like Gecko) Safari/531.2+ Epiphany/2.28.0 SUSE/2.28.0-2.4" =>
        { :type => :Browser, :name => :Epiphany, :version => "2.28.0", :os_name => :Linux, :os_version => "SUSE", :platform => :X11 },
      "Mozilla/5.0 (compatible; Konqueror/4.4; Linux) KHTML/4.4.1 (like Gecko) Fedora/4.4.1-1.fc12" =>
        { :type => :Browser, :name => :Konqueror, :version => "4.4", :os_name => :Linux, :os_version => "Fedora", :platform => :X11 },
      "Mozilla/5.0 (compatible; Konqueror/4.3; Linux 2.6.31-16-generic; X11) KHTML/4.3.2 (like Gecko)" =>
        { :type => :Browser, :name => :Konqueror, :version => "4.3", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Mozilla/5.0 (compatible; Konqueror/4.0; Windows) KHTML/4.0.83 (like Gecko)" =>
        { :type => :Browser, :name => :Konqueror, :version => "4.0", :os_name => :Windows, :os_version => nil, :platform => :Windows },

      # Chrome
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.71 Safari/537.36" =>
        { :type => :Browser, :name => :Chrome, :version => "28.0.1500.71", :major_version => "28.0", :os_name => :MacOSX, :os_version => "10.8.4", :platform => :Macintosh },
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.638.0 Safari/534.16" =>
        { :type => :Browser, :name => :Chrome, :version => "10.0.638.0", :major_version => "10.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.15 (KHTML, like Gecko) Ubuntu/10.10 Chromium/10.0.613.0 Chrome/10.0.613.0 Safari/534.15" =>
        { :type => :Browser, :name => :Chrome, :version => "10.0.613.0", :os_name => :Linux, :os_version => "Ubuntu", :platform => :X11 },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.231 Safari/534.10" =>
        { :type => :Browser, :name => :Chrome, :version => "8.0.552.231", :os_name => :MacOSX, :os_version => "10.6.4", :platform => :Macintosh },

      # Chrome based
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.237 Safari/534.10 chromeframe/8.0.552.237" =>
        { :type => :Browser, :name => :Chromeframe, :version => "8.0.552.237", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; GTB6.6; BTRS26718; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C) chromeframe/8.0.552.237" =>
        { :type => :Browser, :name => :Chromeframe, :version => "8.0.552.237", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532.9 (KHTML, like Gecko) Iron/4.0.280.0 Chrome/4.0.280.0 Safari/532.9" =>
        { :type => :Browser, :name => :Iron, :version => "4.0.280.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Iron/5.0.381.0 Chrome/5.0.381 Safari/533.4" =>
        { :type => :Browser, :name => :Iron, :version => "5.0.381.0", :os_name => :MacOSX, :os_version => "10.5.8", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/534.10 (KHTML, like Gecko) RockMelt/0.8.40.147 Chrome/8.0.552.231 Safari/534.10" =>
        { :type => :Browser, :name => :RockMelt, :version => "0.8.40.147", :os_name => :MacOSX, :os_version => "10.6.6", :platform => :Macintosh },

      # Opera
      "Opera/9.80 (Windows NT 6.1; U; de) Presto/2.7.62 Version/11.00" =>
        { :type => :Browser, :name => :Opera, :version => "11.00", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Opera/9.80 (X11; Linux i686; U; en-GB) Presto/2.6.30 Version/10.62" =>
        { :type => :Browser, :name => :Opera, :version => "10.62", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Opera/9.80 (Windows NT 6.1; U; en) Presto/2.5.24 Version/10.54" =>
        { :type => :Browser, :name => :Opera, :version => "10.54", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Opera/10.00 (X11; Linux i686 ; U; en) Presto/2.2.0" =>
        { :type => :Browser, :name => :Opera, :version => "10.00", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Opera/9.25 (Windows NT 6.0; U; en)" =>
        { :type => :Browser, :name => :Opera, :version => "9.25", :os_name => :Windows, :os_version => "Vista", :platform => :Windows },
      "Mozilla/5.0 (Macintosh; PPC Mac OS X; U; en) Opera 8.5" =>
        { :type => :Browser, :name => :Opera, :version => "8.5", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Mozilla/4.0 (compatible; MSIE 6.0; Mac_PowerPC Mac OS X; en) Opera 8.5" =>
        { :type => :Browser, :name => :Opera, :version => "8.5", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Opera/8.5 (Macintosh; PPC Mac OS X; U; en)" =>
        { :type => :Browser, :name => :Opera, :version => "8.5", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Opera/8.01 (Windows NT 5.1)" =>
        { :type => :Browser, :name => :Opera, :version => "8.01", :major_version => "8.01", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/5.0 (Windows NT 5.1; U; en) Opera 8.01" =>
        { :type => :Browser, :name => :Opera, :version => "8.01", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 5.0; Windows 95) Opera 6.01 [en]" =>
        { :type => :Browser, :name => :Opera, :version => "6.01", :os_name => :Windows, :os_version => "95", :platform => :Windows },

      # Opera Mini/Mobile
      "Opera/9.80 (BlackBerry; Opera Mini/5.1.22303/22.453; U; de) Presto/2.5.25 Version/10.54" =>
        { :type => :Browser, :name => :OperaMini, :version => "5.1.22303", :os_name => :BlackBerry, :os_version => nil, :platform => :BlackBerry },
      "Opera/9.80 (J2ME/MIDP; Opera Mini/5.1.22296/22.453; U; en) Presto/2.5.25 Version/10.54" =>
        { :type => :Browser, :name => :OperaMini, :version => "5.1.22296", :os_name => :"J2ME/MIDP", :os_version => nil, :platform => :"J2ME/MIDP" },
      "Opera/9.60 (J2ME/MIDP; Opera Mini/4.2.13337/504; U; en) Presto/2.2.0" =>
        { :type => :Browser, :name => :OperaMini, :version => "4.2.13337", :os_name => :"J2ME/MIDP", :os_version => nil, :platform => :"J2ME/MIDP" },
      "Opera/9.80 (S60; SymbOS; Opera Mobi/499; U; en-GB) Presto/2.4.18 Version/10.00" =>
        { :type => :Browser, :name => :OperaMobile, :version => "10.00", :os_name => :SymbianOS, :os_version => nil, :platform => :SymbianOS },
      "Opera/9.80 (Linux armv7l; Maemo; Opera Mobi/4; U; de) Presto/2.5.28 Version/10.1" =>
        { :type => :Browser, :name => :OperaMobile, :version => "10.1", :os_name => :Linux, :os_version => "Maemo", :platform => :X11 },

      # MSIE
      "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36 Edge/12.0" =>
        { :type => :Browser, :name => :MSIE, :version => "12.0", :os_name => :Windows, :os_version => "10", :platform => :Windows },
      "Mozilla/5.0 (Windows Phone 10.0; Android 4.2.1; DEVICE INFO) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Mobile Safari/537.36 Edge/12.0" =>
        { :type => :Browser, :name => :MSIE, :version => "12.0", :os_name => :WindowsPhone, :os_version => "10", :platform => :Windows },
      "Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv 11.0) like Gecko" =>
        { :type => :Browser, :name => :MSIE, :version => "11.0", :os_name => :Windows, :os_version => "8.1", :platform => :Windows },
      "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)" =>
        { :type => :Browser, :name => :MSIE, :version => "10.0", :os_name => :Windows, :os_version => "8", :platform => :Windows },
      "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)" =>
        { :type => :Browser, :name => :MSIE, :version => "10.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)" =>
        { :type => :Browser, :name => :MSIE, :version => "9.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Win64; x64; Trident/4.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; Tablet PC 2.0; .NET4.0C; InfoPath.3)" =>
        { :type => :Browser, :name => :MSIE, :version => "8.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; InfoPath.3; .NET4.0E)" =>
        { :type => :Browser, :name => :MSIE, :version => "8.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB6.6)" =>
        { :type => :Browser, :name => :MSIE, :version => "8.0", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; GTB6.4; .NET CLR 1.1.4322; FDM; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)" =>
        { :type => :Browser, :name => :MSIE, :version => "7.0", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; InfoPath.1; .NET CLR 2.0.50727; .NET CLR 1.1.4322; ZangoToolbar 4.8.2)" =>
        { :type => :Browser, :name => :MSIE, :version => "6.0", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 5.14; Mac_PowerPC)" =>
        { :type => :Browser, :name => :MSIE, :version => "5.14", :os_name => :MacOS, :os_version => nil, :platform => :Macintosh },
      "Mozilla/4.0 (compatible; MSIE 5.5; Windows 98; IDG.pl; Alexa Toolbar)" =>
        { :type => :Browser, :name => :MSIE, :version => "5.5", :os_name => :Windows, :os_version => "98", :platform => :Windows },
      "Mozilla/4.0 (compatible; MSIE 7.0)" =>
        { :type => :Browser, :name => :MSIE, :version => "7.0", :os_name => nil, :os_version => nil, :platform => nil },
      "Mozilla/4.0 (compatible; MSIE 6.0; Windows XP)" =>
        { :type => :Browser, :name => :MSIE, :version => "6.0", :os_name => :Windows, :os_version => "XP", :platform => :Windows },

      # iPhone / iPad / iPod
      "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; de-de) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5" =>
        { :type => :Browser, :name => :MobileSafari, :version => "5.0.2", :os_name => :iOS, :os_version => "4.2.1", :platform => :iPhone },
      "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_3 like Mac OS X; de-de) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7E18 Safari/528.16" =>
        { :type => :Browser, :name => :MobileSafari, :version => "4.0", :os_name => :iOS, :os_version => "3.1.3", :platform => :iPhone },
      "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Mobile/8C148" =>
        { :type => :Browser, :name => :MobileSafari, :version => "8C148", :os_name => :iOS, :os_version => "4.2.1", :platform => :iPhone },
      "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5F136 Safari/525.20" =>
        { :type => :Browser, :name => :MobileSafari, :version => "3.1.1", :os_name => :iOS, :os_version => "2.1", :platform => :iPhone },
      "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3" =>
        { :type => :Browser, :name => :MobileSafari, :version => "3.0", :os_name => :iOS, :os_version => nil, :platform => :iPhone },

      "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7" =>
        { :type => :Browser, :name => :MobileSafari, :version => "4.0.5", :os_name => :iOS, :os_version => "4.0", :platform => :iPod },
      "Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11a Safari/525.20" =>
        { :type => :Browser, :name => :MobileSafari, :version => "3.1.1", :os_name => :iOS, :os_version => "2.2.1", :platform => :iPod },
      "Mozilla/5.0 (iPod; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/3A100a Safari/419.3" =>
        { :type => :Browser, :name => :MobileSafari, :version => "3.0", :os_name => :iOS, :os_version => nil, :platform => :iPod },

      "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; es-es) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405" =>
        { :type => :Browser, :name => :MobileSafari, :version => "7B405", :major_version => "7B405", :os_name => :iOS, :os_version => "3.2.1", :platform => :iPad },
      "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; es-es) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B405 Safari/531.21.10" =>
        { :type => :Browser, :name => :MobileSafari, :version => "4.0.4", :os_name => :iOS, :os_version => "3.2.1", :platform => :iPad },
      "Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; de-de) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5" =>
        { :type => :Browser, :name => :MobileSafari, :version => "5.0.2", :os_name => :iOS, :os_version => "4.2.1", :platform => :iPad },

      # Android
      "Mozilla/5.0 (Linux; U; Android 1.1; en-gb; dream) AppleWebKit/525.10+ (KHTML, like Gecko) Version/3.0.4 Mobile Safari/523.12.2" =>
        { :type => :Browser, :name => :AndroidWebkit, :version => "3.0.4", :os_name => :Android, :os_version => "1.1", :platform => :Android },
      "Mozilla/5.0 (Linux; U; Android 0.5; en-us) AppleWebKit/522+ (KHTML, like Gecko) Safari/419.3" =>
        { :type => :Browser, :name => :AndroidWebkit, :version => nil, :os_name => :Android, :os_version => "0.5", :platform => :Android },
      "Mozilla/5.0 (Linux; U; Android 2.1; en-us; Nexus One Build/ERD62) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17" =>
        { :type => :Browser, :name => :AndroidWebkit, :version => "4.0", :os_name => :Android, :os_version => "2.1", :platform => :Android },

      # Palm (Pre)
      "Mozilla/5.0 (webOS/1.3; U; en-US) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/1.0 Safari/525.27.1 Desktop/1.0" =>
        { :type => :Browser, :name => :webOSWebkit, :version => "1.0", :os_name => :webOS, :os_version => "1.3", :platform => :webOS },

      # Mobiles
      "Mozilla/4.1 (compatible; MSIE 5.0; Symbian OS; Nokia 3650;424) Opera 6.10 [en]" =>
        { :type => :Browser, :name => :OperaMobile, :version => "6.10", :os_name => :SymbianOS, :os_version => nil, :platform => :SymbianOS },
      "Mozilla/4.0 (compatible; MSIE 6.0; Symbian OS; Nokia 6600/4.09.1; 6329) Opera 8.00 [en]" =>
        { :type => :Browser, :name => :OperaMobile, :version => "8.00", :os_name => :SymbianOS, :os_version => nil, :platform => :SymbianOS },
      "Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaX6-00/30.0.003; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.6.6 3gpp-gba,gzip(gfe),gzip(gfe),gzip(gfe)" =>
        { :type => :Browser, :name => :AppleWebKit, :version => "525", :os_name => :SymbianOS, :os_version => "9.4", :platform => :SymbianOS },
      "Mozilla/5.0 (SymbianOS/9.2; U; Series60/3.1 Nokia6120c/3.83; Profile/MIDP-2.0 Configuration/CLDC-1.1) AppleWebKit/413 (KHTML, like Gecko) Safari/413" =>
        { :type => :Browser, :name => :Safari, :version => "413", :os_name => :SymbianOS, :os_version => "9.2", :platform => :SymbianOS },
      "Mozilla/5.0 (SymbianOS/9.1; U; en-us) AppleWebKit/413 (KHTML, like Gecko) Safari/413 es61i" =>
        { :type => :Browser, :name => :AppleWebKit, :version => "413", :os_name => :SymbianOS, :os_version => "9.1", :platform => :SymbianOS },
      "HTC_HD2_T8585 Opera/9.70 (Windows NT 5.1; U; de)" =>
        { :type => :Browser, :name => :Opera, :version => "9.70", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "Swisscom/1.0/HTC_Touch_Pro/ Opera/9.50 (Windows NT 5.1; U; de)" =>
        { :type => :Browser, :name => :Opera, :version => "9.50", :os_name => :Windows, :os_version => "XP", :platform => :Windows },

      # ApiClients
      "curl/7.20.0 (x86_64-pc-linux-gnu) libcurl/7.20.0 OpenSSL/0.9.8l zlib/1.2.3" =>
        { :type => :ApiClient, :name => :curl, :version => "7.20.0", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Wget/1.12 (linux-gnu)" =>
        { :type => :ApiClient, :name => :Wget, :version => "1.12", :os_name => :Linux, :os_version => nil, :platform => :X11 },
      "Wget/1.10.1 (simple)" =>
        { :type => :ApiClient, :name => :Wget, :version => "1.10.1", :os_name => nil, :os_version => nil, :platform => nil },
      "Yahoo Pipes 2.0" =>
        { :type => :ApiClient, :name => :YahooPipes, :version => "2.0", :os_name => nil, :os_version => nil, :platform => nil },
      "Zendesk" =>
        { :type => :ApiClient, :name => :Zendesk, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Zend_Http_Client" =>
        { :type => :ApiClient, :name => :Zend_Http_Client, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Python-urllib/2.6" =>
        { :type => :ApiClient, :name => :"Python-urllib", :version => "2.6", :os_name => nil, :os_version => nil, :platform => nil },
      "Python-httplib2/$Rev$ (simple)" =>
        { :type => :ApiClient, :name => :"Python-httplib2", :version => "$Rev$", :os_name => nil, :os_version => nil, :platform => nil },
      "Ruby" =>
        { :type => :ApiClient, :name => :Ruby, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "PEAR HTTP_Request class ( http://pear.php.net/ )" =>
        { :type => :ApiClient, :name => :PearPHPHttpRequest, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "HTTP_Request2/0.5.1 (http://pear.php.net/package/http_request2) PHP/5.3.2" =>
        { :type => :ApiClient, :name => :PearPHPHttpRequest, :version => "0.5.1", :os_name => nil, :os_version => nil, :platform => nil },
      "NativeHost" =>
        { :type => :ApiClient, :name => :CappucinosNativeHost, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Java/1.6.0_20" =>
        { :type => :ApiClient, :name => :Java, :version => "1.6.0_20", :major_version => "1.6", :os_name => nil, :os_version => nil, :platform => nil },
      "Systemeinstellungen5.2 CFNetwork/438.16 Darwin/9.8.0 (i386) (MacBookPro5%2C5)" =>
        { :type => :ApiClient, :name => :SystemPreferences, :version => nil, :major_version => nil, :os_name => :MacOSX, :os_version => "10.5.8", :platform => :Macintosh },
      "Systemeinstellungen/7.0 CFNetwork/454.11.5 Darwin/10.6.0 (i386) (iMac8%2C1)" =>
        { :type => :ApiClient, :name => :SystemPreferences, :version => "7.0", :os_name => :MacOSX, :os_version => "10.6.6", :platform => :Macintosh },
      "SystemUIServer248.9 CFNetwork/438.16 Darwin/9.8.0 (i386) (iMac8%2C1)" =>
        { :type => :ApiClient, :name => :SystemUIServer, :version => nil, :os_name => :MacOSX, :os_version => "10.5.8", :platform => :Macintosh },
      "SystemUIServer/298.16 CFNetwork/454.11.5 Darwin/10.5.0 (i386) (MacPro3%2C1)" =>
        { :type => :ApiClient, :name => :SystemUIServer, :version => "298.16", :os_name => :MacOSX, :os_version => "10.6.5", :platform => :Macintosh },
      "AppEngine-Google; (+http://code.google.com/appengine; appid: aquantum-todo)" =>
        { :type => :ApiClient, :name => :"AppEngine-Google", :version => "appid: aquantum-todo", :os_name => nil, :os_version => nil, :platform => nil },
      "AppEngine-Google; (+http://code.google.com/appengine)" =>
        { :type => :ApiClient, :name => :"AppEngine-Google", :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Twisted PageGetter" =>
        { :type => :ApiClient, :name => :PythonTwistedPageGetter, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)" =>
        { :type => :ApiClient, :name => :facebookexternalhit, :version => "1.1", :os_name => nil, :os_version => nil, :platform => nil },

      # Others
      "1PasswordThumbs/1 CFNetwork/454.11.5 Darwin/10.0.0 (i386) (MacBookPro4%2C1)" =>
        { :type => :Others, :name => :"1PasswordThumbs", :version => "1", :os_name => :MacOSX, :os_version => "10.6", :platform => :Macintosh },
      "1PasswordThumbs1 CFNetwork/438.16 Darwin/9.8.0 (i386) (MacBook5%2C1)" =>
        { :type => :Others, :name => :"1PasswordThumbs", :version => "1", :os_name => :MacOSX, :os_version => "10.5.8", :platform => :Macintosh },
      "Mozilla/5.0 (Macintosh; Intel Mac OS X) Word/12.25.0" =>
        { :type => :Others, :name => :MSWord, :version => "12.25.0", :os_name => :MacOSX, :os_version => nil, :platform => :Macintosh },
      "Microsoft Office/14.0 (Windows NT 6.1; Microsoft Outlook 14.0.5128; Pro; ms-office; MSOffice 14)" =>
        { :type => :Others, :name => :MSOffice, :version => "14.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Flint/165 CFNetwork/520.5.1 Darwin/11.4.2 (x86_64) (MacBookPro10%2C1)" =>
        { :type => :Others, :name => :"Flint", :version => "165", :os_name => :MacOSX, :os_version => "10.7.5", :platform => :Macintosh },

      # HttpCheckers
      "check_http/v2053 (nagios-plugins 1.4.13)" =>
        { :type => :HttpChecker, :name => :Nagios, :version => "v2053", :major_version => "v2053", :os_name => nil, :os_version => nil, :platform => nil },
      "Pingdom.com_bot_version_1.4_(http://www.pingdom.com/)" =>
        { :type => :HttpChecker, :name => :PingdomBot, :version => "1.4", :major_version => "1.4", :os_name => nil, :os_version => nil, :platform => nil },
      "NewRelicPinger/1.0" =>
        { :type => :HttpChecker, :name => :NewRelicPinger, :version => "1.0", :os_name => nil, :os_version => nil, :platform => nil },
      "W3C_Validator/1.1" =>
        { :type => :HttpChecker, :name => :W3C_Validator, :version => "1.1", :os_name => nil, :os_version => nil, :platform => nil },
      "FeedValidator/1.3" =>
        { :type => :HttpChecker, :name => :FeedValidator, :version => "1.3", :os_name => nil, :os_version => nil, :platform => nil },

      # Feed Reader/Parser
      "hawkReader/0.9b (Feed Parser; http://www.hawkreader.com; Allow like Gecko)" =>
        { :type => :FeedReader, :name => :hawkReader, :version => "0.9b", :os_name => nil, :os_version => nil, :platform => nil  },
      "Fever/1.31 (Feed Parser; http://feedafever.com; Allow like Gecko)" =>
        { :type => :FeedReader, :name => :Fever, :version => "1.31", :os_name => nil, :os_version => nil, :platform => nil  },
      "Superfeedr bot/2.0 http://superfeedr.com - Make your feeds realtime: get in touch!" =>
        { :type => :FeedReader, :name => :Superfeedr, :version => "2.0", :os_name => nil, :os_version => nil, :platform => nil  },
      "Feedly/1.0 (+http://www.feedly.com/fetcher.html; like FeedFetcher-Google)" =>
        { :type => :FeedReader, :name => :Feedly, :version => "1.0", :os_name => nil, :os_version => nil, :platform => nil },
      "FeedlyApp/1.0 (http://www.feedly.com)" =>
        { :type => :FeedReader, :name => :FeedlyApp, :version => "1.0", :os_name => nil, :os_version => nil, :platform => nil },
      "Feedbin" =>
        { :type => :FeedReader, :name => :Feedbin, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Feedbin - 1 subscribers" =>
        { :type => :FeedReader, :name => :Feedbin, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Windows-RSS-Platform/2.0 (MSIE 9.0; Windows NT 6.1)" =>
        { :type => :FeedReader, :name => :"Windows-RSS-Platform", :version => "2.0", :os_name => :Windows, :os_version => "7", :platform => :Windows },
      "Vienna/2.5.0.2501" =>
        { :type => :FeedReader, :name => :Vienna, :version => "2.5.0.2501", :os_name => nil, :os_version => nil, :platform => nil },
      "NewsGatorOnline/2.0 (http://www.newsgator.com; 1 subscribers)" =>
        { :type => :FeedReader, :name => :NewsGatorOnline, :version => "2.0", :os_name => nil, :os_version => nil, :platform => nil },
      "FeedDemon/2.7 (http://www.newsgator.com/; Microsoft Windows XP)" =>
        { :type => :FeedReader, :name => :FeedDemon, :version => "2.7", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "FeedDemon/4.0 (http://www.feeddemon.com/; Microsoft Windows XP)" =>
        { :type => :FeedReader, :name => :FeedDemon, :version => "4.0", :os_name => :Windows, :os_version => "XP", :platform => :Windows },
      "NewsFire/84 CFNetwork/454.11.5 Darwin/10.4.1 (i386) (iMac11%2C3)" =>
        { :type => :FeedReader, :name => :NewsFire, :version => "84", :os_name => :MacOSX, :os_version => "10.6.4", :platform => :Macintosh },
      "NetNewsWire/3.2b24 (Mac OS X; http://www.newsgator.com/Individuals/NetNewsWire/)" =>
        { :type => :FeedReader, :name => :NetNewsWire, :version => "3.2b24", :os_name => nil, :os_version => nil, :platform => nil },
      "MWFeedParser" =>
        { :type => :FeedReader, :name => :MWFeedParser, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "SimplePie/1.1.1 (Feed Parser; http://simplepie.org; Allow like Gecko) Build/20080315205900" =>
        { :type => :FeedReader, :name => :SimplePie, :version => "1.1.1", :os_name => nil, :os_version => nil, :platform => nil },
      "MagpieRSS/0.72 \(+http://magpierss.sf.net\)" =>
        { :type => :FeedReader, :name => :MagpieRSS, :version => "0.72", :os_name => nil, :os_version => nil, :platform => nil },
      "Feedfetcher-Google; (+http://www.google.com/feedfetcher.html; feed-id=6486597085114830250)" =>
        { :type => :FeedReader, :name => :"Feedfetcher-Google", :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Feedfetcher-Google; (+http://www.google.com/feedfetcher.html; 1 subscribers; feed-id=10493421032871565854)" =>
        { :type => :FeedReader, :name => :"Feedfetcher-Google", :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Apple-PubSub/65.20" =>
        { :type => :FeedReader, :name => :"Apple-PubSub", :version => "65.20", :os_name => nil, :os_version => nil, :platform => nil },
      "Netvibes (http://www.netvibes.com/; 1 subscribers; feedID: 6639445)" =>
        { :type => :FeedReader, :name => :Netvibes, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "AppleSyndication/38" =>
        { :type => :FeedReader, :name => :AppleSyndication, :version => "38", :os_name => nil, :os_version => nil, :platform => nil },
      "Tumblr/1.0 RSS syndication (+http://www.tumblr.com/) (support@tumblr.com)" =>
        { :type => :FeedReader, :name => :TumblrRSSSyndication, :version => "1.0", :os_name => nil, :os_version => nil, :platform => nil },
      "Reeder/1010.69.00 CFNetwork/520.3.2 Darwin/11.3.0 (x86_64) (MacBookPro6%2C2)" =>
        { :type => :FeedReader, :name => :Reeder, :version => "1010.69.00", :os_name => :Darwin, :os_version => "11.3.0", :platform => :Darwin },
      "FeeddlerPro 1.12.5 (iPad; iPhone OS 6.1.3; de_DE)" =>
        { :type => :FeedReader, :name => :FeeddlerPro, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "FeeddlerRSS 1.12.5 (iPad; iPhone OS 6.1.3; de_DE)" =>
        { :type => :FeedReader, :name => :FeeddlerRSS, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "FreeRSSReader/1.9.5 CFNetwork/672.0.2 Darwin/14.0.0" =>
        { :type => :FeedReader, :name => :FreeRSSReader, :version => "1.9.5", :os_name => :Darwin, :os_version => "14.0.0", :platform => :Darwin },

      # SearchBots
      "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" =>
        { :type => :SearchBot, :name => :Bingbot, :version => "2.0", :os_name => nil, :os_version => nil, :platform => nil },
      "Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)" =>
        { :type => :SearchBot, :name => :YahooSlurp, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Baiduspider+(+http://www.baidu.jp/spider/)" =>
        { :type => :SearchBot, :name => :Baiduspider, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Baiduspider+(+http://www.baidu.com/search/spider.htm)" =>
        { :type => :SearchBot, :name => :Baiduspider, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },
      "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.htm)" =>
        { :type => :SearchBot, :name => :Baiduspider, :version => "2.0", :os_name => nil, :os_version => nil, :platform => nil },
      "msnbot/2.0b (+http://search.msn.com/msnbot.htm)._" =>
        { :type => :SearchBot, :name => :msnbot, :version => "2.0b", :os_name => nil, :os_version => nil, :platform => nil },
      "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" =>
        { :type => :SearchBot, :name => :Googlebot, :version => "2.1", :os_name => nil, :os_version => nil, :platform => nil },
      "DoCoMo/2.0 N905i(c100;TB;W24H16) (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)" =>
        { :type => :SearchBot, :name => :GooglebotMobile, :version => "2.1", :os_name => nil, :os_version => nil, :platform => nil },
      "FLUX-Toolchain/0.5 +http://odo.dwds.de/dwds-crawler.html" =>
        { :type => :SearchBot, :name => :DWDSCrawler, :version => nil, :os_name => nil, :os_version => nil, :platform => nil },

      # Engine Fallbacks
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-au) AppleWebKit/533.19.4 (KHTML, like Gecko)" =>
        { :type => :Browser, :name => :AppleWebKit, :version => "533.19.4", :os_name => :MacOSX, :os_version => "10.6.6", :platform => :Macintosh },
      "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; de-de) AppleWebKit/533.17.9 (KHTML, like Gecko) 1Password/3.5.5/355003 (like Mobile/8C148 Safari/6533.18.5)" =>
        { :type => :Browser, :name => :AppleWebKit, :version => "533.17.9", :os_name => :iOS, :os_version => "4.2.1", :platform => :iPhone },
      "Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.14pre) Gecko/20110113 Ubuntu/9.10 (karmic)" =>
        { :type => :Browser, :name => :Gecko, :version => "20110113", :os_name => :Linux, :os_version => "Ubuntu", :platform => :X11 },
      "Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20070606" =>
        { :type => :Browser, :name => :Gecko, :version => "20070606", :major_version => "20070606", :os_name => :Linux, :os_version => "Solaris", :platform => :X11 },
      "Mozilla/5.0 (X11; U; FreeBSD i386; en-US; rv:1.7.12) Gecko/20051105" =>
        { :type => :Browser, :name => :Gecko, :version => "20051105", :os_name => :Linux, :os_version => "FreeBSD", :platform => :X11 },

      "Raven/0.7.14612 CFNetwork/520.3.2 Darwin/11.3.0 (x86_64) (iMac12%2C2)" =>
        { :type => :Browser, :name => :Raven, :version => "0.7.14612", :os_name => :Darwin, :os_version => "11.3.0", :platform => :Darwin },
    }

    EXAMPLES.each do |string, values|
      context "when parsing #{string.inspect}" do
        let(:user_agent) { Aua.parse(string) }
        values.each do |key, value|
          it "should return #{value} for #{key}" do
            user_agent.send(key).should eql(value)
          end
        end
      end
    end
  end

  context "empty String" do
    its(:raw) { should eql("")}
    its(:products) { should eql([]) }
    its(:versions) { should eql([]) }
    its(:comments) { should eql([]) }

    it "should return nil on #version_of" do
      subject.version_of(nil).should eql(nil)
      subject.version_of("Firefox").should eql(nil)
    end

    its(:os_string) { should eql(nil) }
    its(:platform_string)    { should eql(nil) }

    its(:name)        { should eql("") }
    its(:type)        { should eql(:Unknown) }
    its(:version)     { should eql(nil) }
    its(:os_name)     { should eql(nil) }
    its(:os_version)  { should eql(nil) }
    its(:platform)    { should eql(nil) }

    it{ should be_unknown }
    its(:to_s) { should eql("Unknown: ")}
  end

  context "standard user agent string" do
    subject{ Aua.new("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13") }

    its(:raw) { should eql("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13")}
    its(:products) { should eql(["Mozilla", "Gecko", "Firefox"]) }
    its(:versions) { should eql(["5.0", "20101203", "3.6.13"]) }
    its(:comments) { should eql([["Macintosh", "U", "Intel Mac OS X 10.6", "de", "rv:1.9.2.13"], [], []]) }

    it "should return version on #version_of" do
      subject.version_of("Mozilla").should eql("5.0")
      subject.version_of("Firefox").should eql("3.6.13")
    end

    its(:platform_string) { should eql("Macintosh") }
    its(:os_string) { should eql("Intel Mac OS X 10.6") }

    it{ should_not be_unknown }
    its(:to_s) { should eql("Browser Firefox/3.6.13 MacOSX/10.6 Macintosh")}
  end

  context "unknown user agent string" do
    subject{ Aua.new("Mozilla/5.0 (Bla; U; Krank; de; rv:1.9.2.13) Less/20101203 Vrrrr/3.6.13") }

    its(:raw) { should eql("Mozilla/5.0 (Bla; U; Krank; de; rv:1.9.2.13) Less/20101203 Vrrrr/3.6.13")}
    its(:products) { should eql(["Mozilla", "Less", "Vrrrr"]) }
    its(:versions) { should eql(["5.0", "20101203", "3.6.13"]) }
    its(:comments) { should eql([["Bla", "U", "Krank", "de", "rv:1.9.2.13"], [], []]) }

    it "should return version on #version_of" do
      subject.version_of("Mozilla").should eql("5.0")
      subject.version_of("Vrrrr").should eql("3.6.13")
    end

    its(:platform_string) { should eql("Bla") }
    its(:os_string) { should eql("Krank") }

    it{ should be_unknown }
    its(:to_s) { should eql("Unknown: Mozilla/5.0 (Bla; U; Krank; de; rv:1.9.2.13) Less/20101203 Vrrrr/3.6.13")}

    its(:name)        { should eql("Mozilla/5.0 (Bla; U; Krank; de; rv:1.9.2.13) Less/20101203 Vrrrr/3.6.13") }
    its(:type)        { should eql(:Unknown) }
    its(:version)     { should eql(nil) }
    its(:os_name)     { should eql(nil) }
    its(:os_version)  { should eql(nil) }
    its(:platform)    { should eql(nil) }
  end

  context "unknown simple user agent string" do
    subject{ Aua.new("my_mite_app/v1.0") }

    its(:raw) { should eql("my_mite_app/v1.0")}
    its(:products) { should eql(["my_mite_app"]) }
    its(:versions) { should eql(["v1.0"]) }
    its(:comments) { should eql([[]]) }

    it{ should be_unknown }
    its(:to_s) { should eql("Unknown: my_mite_app/v1.0 (simple)")}

    its(:name)        { should eql("my_mite_app") }
    its(:type)        { should eql(:Unknown) }
    its(:version)     { should eql("v1.0") }
    its(:os_name)     { should eql(nil) }
    its(:os_version)  { should eql(nil) }
    its(:platform)    { should eql(nil) }
  end
end