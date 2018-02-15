module SnipSnapZap
  class SnapSchedulesController < ApplicationController
    before_filter :fetch_classes
    before_filter :load_snap_schedules


    private

    def fetch_classes
      @klasses = SnipSnapZap::SnapSchedule.uniq_types.pluck(:schedulable_type)
    end

    def load_snap_schedules
      if params[:filter].present?
        # if filter_params.length == 1 && filter_params[:schedulable_type]
        #   Rails.logger.debug "IF PARAMS: #{filter_params.inspect}"
        #   @snap_schedules = SnipSnapZap::SnapSchedule.uniq_ids_for_type(filter_params[:schedulable_type])
        #   Rails.logger.debug @snap_schedules.inspect
        #   return
        # else
        Rails.logger.debug "ELSE PARAMS: #{filter_params.inspect}"
        @snap_schedules = SnipSnapZap::SnapSchedule.where(filter_params)
        Rails.logger.debug @snap_schedules.inspect
        return
      end
    end

    def filter_params
      params.require(:filter).permit(
        :schedulable_type,
        :schedulable_id
      )
    end
  end
end
