module SnipSnapZap::Engine
  class SnapEngine < Rails::Engine
    isolate_namespace SnapEngine
    engine_name 'snip_snap_zap'

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")).each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    # Because development doesn't play nicely 100% of the time with serialized columns
    # Sometimes they are returned as YAML strings rather than the unserialized object
    if Rails.env.development?
      # Eager load all value objects, as they may be instantiated from
      # YAML before the symbol is referenced
      config.before_initialize do |app|
          app.config.paths.add 'app/models', :eager_load => true
      end

      # Reload cached/serialized classes before every request (in development
      # mode) or on startup (in production mode)
      config.to_prepare do
          Dir[ File.expand_path(Rails.root.join("app/models/*.rb")) ].each do |file|
              require_dependency file
          end
          # require_dependency 'article_cache'
      end
    end
  end # Engine
end