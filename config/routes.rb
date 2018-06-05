Rails.application.routes.draw do
  namespace :snip_snap_zap do
    resources :snap_schedules do
      resources :snip_snaps
    end

    resources :stats do
      collection do 
        get :kickoff_stats
      end
    end
  end
end