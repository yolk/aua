module Aua::StackBase
  def extend_agent(agent)
    default.each do |mod|
      if mod.extend?(agent)
        agent.extend(mod)
        break
      end
    end
  end
end