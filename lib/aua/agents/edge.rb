module Aua::Agents::Edge
  def self.extend?(agent)
    agent.products.include?("Safari") && agent.products.include?("Chrome") && (
      agent.products.include?("Edge") ||
      agent.products.include?("Edg") ||
      agent.products.include?("EdgA")
    )
  end

  def type
    :Browser
  end

  def name
    :Edge
  end

  def version
    @version ||= version_of("Edg") || version_of("Edge") || version_of("EdgA")
  end

  def major_version
    @major_version ||= (version || "").split('.', 2)[0]
  end
end
