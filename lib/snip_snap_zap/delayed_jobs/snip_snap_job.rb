module SnipSnapZap
  module DelayedJobs
    class SnipSnapJob < Struct.new(:ownable_type, :ownable_id)
      include Delayed::RecurringJob

      def enqueue(job)
        job.ownable_type = self.ownable_type
        job.ownable_id   = self.ownable_id
      end

      def perform
        snapable = ownable_guy.schedulable

        new_attrs = ownable_guy.snipable_attributes.map do |key|
          {key => assoc_to_h( snapable.try(key) )}
        end.reduce({}, :merge)

        new_snap = SnipSnap.new(snap_schedule_id: ownable_guy.id, snapable: snapable, modified_attributes: new_attrs)
        previous_version = SnipSnap.siblings(new_snap).by_version.try(:last)

        if previous_version
          previous_attributes = previous_version.modified_attributes

          return if previous_attributes == new_attrs
          new_snap.previous_attributes = previous_version.modified_attributes
        end
        
        new_snap.save
      end

      private
      def ownable_guy
        self.ownable_type.constantize.find(self.ownable_id)
      end

      # Convert an object returned by an association into a hash
      def assoc_to_h(obj)
        Rails.logger.debug "OBJ: #{obj}"
        Rails.logger.debug "ATTRIBUTES?: #{obj.respond_to?(:attributes)}"
        Rails.logger.debug "MAP?: #{respond_to?(:map)}"
        if obj.respond_to? :attributes
          obj.attributes
        elsif obj.respond_to?(:map)
          obj.map do |el|
            assoc_to_h(el)
          end
        else
          obj
        end
      end
    end
  end
end