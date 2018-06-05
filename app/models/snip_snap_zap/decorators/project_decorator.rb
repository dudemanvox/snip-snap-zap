Project.class_eval do
  # Checks the personnel columns for a matching name
  def personnel?(person)
    [researchDirector, secondaryResearchDirector, researchPlanner].include?(person.first_last)
  end # personnel?
end # class_eval