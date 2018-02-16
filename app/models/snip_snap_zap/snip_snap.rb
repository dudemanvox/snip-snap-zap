#
# snapable_type       string
# snapable_id         integer
# snap_schedule_id    integer
# version             integer
# previous_attributes text
# modified_attributes text

module SnipSnapZap
  class SnipSnap < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    serialize :previous_attributes, Hash
    serialize :modified_attributes, Hash

    #  ================
    #  = Associations =
    #  ================
    belongs_to :snapable, polymorphic: true
    belongs_to :snap_schedule
    has_many   :delayed_jobs, through: :snap_schedules

    #  ==========
    #  = Scopes =
    #  ==========
    scope :by_version, ->{ order("version ASC") }
    scope :siblings, ->(snip_snap){ where(snapable_type: snip_snap.snapable_type, snapable_id: snip_snap.snapable_id, snap_schedule_id: snip_snap.snap_schedule_id) }
    scope :uniq_types, ->{ select("DISTINCT(snapable_type)") }
    scope :uniq_ids_for_type, ->(type){ select("DISTINCT(snapable_id)").where(snapable_type: type) }
    #  =============
    #  = Callbacks =
    #  =============
    before_save :set_version
    after_save  :check_for_stop

    # private

      def set_version
        version = self.class.siblings(self).by_version.try(:last).try(:version)
        unless version
          version = 1
        else
          version += 1
        end

        self.version = version
      end

      # See if the stoppable attributes have been met
      def check_for_stop
        return unless snap_schedule.stoppable_attributes.present?
        puts snap_schedule.stoppable_attributes.first.stringify_keys.inspect
        puts self.snapable.attributes.slice(*snap_schedule.stoppable_attributes.first.stringify_keys.keys).inspect
        if snap_schedule.stoppable_attributes.first.stringify_keys == self.snapable.attributes.slice(*snap_schedule.stoppable_attributes.first.stringify_keys.keys)
          self.snap_schedule.update_column(:active, false)
        end
      end
  end
end