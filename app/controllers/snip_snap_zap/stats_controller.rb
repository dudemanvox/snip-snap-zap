class SnipSnapZap::StatsController < ApplicationController
  before_filter :load_people
  before_filter :load_kickoff_schedules, only: [:kickoff_stats]


  def kickoff_stats
    @projects = @schedules.map{|sch| sch.schedulable.project}
  end # index

  private

  def load_people
    @people = Person.directors_and_planners.current_user
  end # load_people

  def load_kickoff_schedules
    # Load the SnapSchedules, their snaps, the snapable object (kickoff form) and its project
    @schedules = SnipSnapZap::SnapSchedule.project_kickoffs.includes(:snip_snaps, schedulable: [project: :project_setups]).group_by
  end # load_kickoff_schedules

end # StatsController