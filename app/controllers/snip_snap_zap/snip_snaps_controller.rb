class SnipSnapZap::SnipSnapsController < ApplicationController
  before_filter :fetch_classes
  before_filter :load_snap_schedule
  before_filter :load_snip_snaps

  # helper SnipSnapZap::SnapEngine::Helpers::SnipSnapHelper

  def index
    
  end

  def show

  end

  private

    def fetch_classes
      @klasses = SnipSnapZap::SnipSnap.uniq_types.pluck(:snapable_type)
    end

    def load_snap_schedule
      @snap_schedule = SnipSnapZap::SnapSchedule.find(params[:snap_schedule_id])
    end

    def load_snip_snaps
      @snip_snaps = load_snap_schedule.snip_snaps
    end

    def filter_params
      params.require(:filter).permit(
        :snapable_type,
        :snapable_id
      )
    end
end