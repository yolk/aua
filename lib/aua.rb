class Aua
  MATCHER = %r{
    ^([^\s/]+)        # Product
    /?([^\s]*)        # Version
    (\s\(([^\)]*)\))? # Comment
  }x.freeze

  def initialize(string="")
    @raw = string.to_s
    parse
  end

  def self.parse(raw)
    new(raw)
  end

  def parse
    string = @raw.dup
    @parts = []
    while m = string.match(MATCHER)
      @parts << [m[1] ? m[1].sub(/;$/,"") : m[1], m[2], m[4] ? m[4].split(/\s?;\s?/) : []]
      string = string.sub(m[0], '').strip
    end

    Aua::Agents.extend_agent(self)
    Aua::OperatingSystems.extend_agent(self)
  end

  attr_reader :version, :os_name, :os_version, :parts, :raw, :platform

  def name
    @name unless unknown?
    if simple?
      app
    else
      raw
    end
  end

  def type
    @type || :Unknown
  end

  def version
    @version ||= name ? version_of(name) : nil
  end

  MAJOR_VERSION = /^([\d]+)\.([\d]+[a-z]*)/

  def major_version
    @major_version ||= (version || "") =~ MAJOR_VERSION ? "#{$1}.#{$2}" : version
  end

  def os_major_version
    @os_major_version ||= (os_version || "") =~ MAJOR_VERSION ? "#{$1}.#{$2}" : os_version
  end

  def products
    @products ||= parts.map{|p| p[0] }
  end

  def versions
    @versions ||= parts.map{|p| p[1] != "" ? p[1] : nil }
  end

  def app
    products[0]
  end

  def comments
    @comments ||= parts.map{|p| p[2] }
  end

  def app_comments
    @app_comments ||= (comments.first || []) + [""]*5
  end

  def app_comments_string
    @app_comments_string ||= (comments.first || []).join(";")
  end

  def comments_string
    @comments_string ||= comments.flatten.join(";")
  end

  def version_of(product)
    i = products.index(product.to_s)
    versions[i] if i && versions[i] != ""
  end

  def platform_string
    @platform_string ||= comments.first && comments.first.first
  end

  def os_string
    @os_string ||= comments.first && comments.first[2]
  end

  def unknown?
    type == :Unknown
  end

  def simple?
    products.size == 1 && versions.size <= 1 && comments == [[]]
  end

  def to_s
    return "Unknown: #{raw}#{" (simple)" if simple?}" if unknown?
    "#{type} #{name}/#{version} #{os_name}/#{os_version} #{platform}"
  end
end

require 'aua/agents'
require 'aua/operating_systems'
