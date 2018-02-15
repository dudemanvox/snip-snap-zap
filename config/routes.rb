Rails.application.routes.draw do
  namespace :snip_snap_zap do
    resources :snap_schedules do
      resources :snip_snaps
    end
  end
end