module Aua::Agents::Others
  KNOWN_CLIENTS = %w(1PasswordThumbs 1PasswordThumbs1)

  def self.extend?(agent)
    KNOWN_CLIENTS.include?(agent.app) ||
    (agent.app == "Microsoft" && agent.products[1] == "Office") ||
    agent.products[-1] == "Word"
  end

  def type
    :Others
  end

  def name
    @name ||= begin
      if app == "Microsoft" && products[1] == "Office"
        :MSOffice
      elsif products[-1] == "Word"
        :MSWord
      elsif app == "1PasswordThumbs1"
        :"1PasswordThumbs"
      else
        app.to_sym
      end
    end
  end

  def version
    @version ||= begin
      return version_of("Word") if name == :MSWord
      return version_of("Office") if name == :MSOffice
      return "1" if app == "1PasswordThumbs1"
      super
    end
  end
end