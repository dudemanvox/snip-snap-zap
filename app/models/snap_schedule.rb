# schedulable_type       string
# schedulable_id         integer
# snipable_attributes    text
# active                 boolean
# start_at               datetime
# frequency_num          integer
# frequency_unit         string

module SnipSnapZap
  class SnapSchedule < ActiveRecord::Base

    # Serialize to store as YAML
    serialize :snipable_attributes, Array
    serialize :stoppable_attributes, Array

    #  ================
    #  = Associations =
    #  ================
    belongs_to :schedulable, polymorphic: true
    # TODO: Make this dynamic - eventually we'll have a model generator
    has_many :delayed_jobs, as: :ownable
    has_many :snip_snaps

    #  ==========
    #  = Scopes =
    #  ==========
    scope :active, ->{ where(active: true) }
    scope :inactive, ->{ where(active: false) }
    scope :with_jobs, ->{ includes(:delayed_jobs).where("delayed_jobs.id IS NOT NULL") }
    scope :without_jobs, ->{ includes(:delayed_jobs).where(delayed_jobs: {id: nil}) }
    scope :uniq_types, ->{ select("DISTINCT(schedulable_type)") }
    scope :uniq_ids_for_type, ->(type){ select("DISTINCT(schedulable_id)").where(schedulable_type: type) }

    scope :project_kickoffs, ->{ where(schedulable_type: "ProjectSetup") }

    def run_at
      start_at.strftime("%I:%M%p")
    end

    def run_every
      frequency_num.to_i.try(frequency_unit.to_sym)
    end

    # When should this run again?
    def date_of_next_occurrence
      return unless active?
      start_at
    end

    # When was this last run?
    def date_of_last_occurrence
      return if has_not_occurred?
    end

    # Active is true
    def active?
      active
    end

    # Active is false
    def inactive?
      !active
    end

    # If the start_at date is in the future
    def has_not_occurred?
      self.start_at > Date.today
    end

  end
end