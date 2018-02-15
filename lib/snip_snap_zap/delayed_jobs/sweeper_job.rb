require "delayed/recurring_job"
require "snip_snap_zap/delayed_jobs.rb"
module SnipSnapZap
  module DelayedJobs
    class SweeperJob
      include Delayed::RecurringJob

      def self.schedule!
        run_every SnipSnapZap.configuration.run_every
        run_at    SnipSnapZap.configuration.run_at
        timezone  SnipSnapZap.configuration.timezone
        queue     SnipSnapZap.configuration.queue_name
        super
      end

      def perform
        # Clean up any jobs belonging to deactivated schedules
        remove_jobs
        # Create jobs for any newly activated schedules
        create_jobs
      end

      def create_jobs
        active_schedules = SnipSnapZap::SnapSchedule.active.without_jobs

        active_schedules.each do |s|
          SnipSnapJob.schedule!(run_at: s.run_at, run_every: s.run_every, timezone: Time.zone.name , queue: 'snap_shots', job_options: {ownable_type: s.class.name, ownable_id: s.id})
        end
      end

      def remove_jobs
        deactivate_schedules = SnipSnapZap::SnapSchedule.inactive.with_jobs

        deactivate_schedules.each do |s|
          s.delayed_jobs.destroy_all
        end
      end

      def self.module_nesting
        Module.nesting
      end
    end
  end
end