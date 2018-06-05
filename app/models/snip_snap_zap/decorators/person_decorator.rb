Person.class_eval do
  #  ==========
  #  = Scopes =
  #  ==========
    scope :directors_and_planners, ->{ where(personTitle: ["Research Director", "Associate Research Director", "Research Planner", "Associate Research and Planning Director"]).company("Ameritest")  }

    def first_last
      "#{firstName} #{lastName}"
    end # first_last
end # class_eval