require "snip_snap_zap/version"
require "snip_snap_zap/configuration"
require "snip_snap_zap/engine/snap_engine"
# require "snip_snap_zap/helpers/snip_snap_helper"

# Require the models
require_relative "../app/models/snap_schedule"
require_relative "../app/models/snip_snap_zap/snip_snap"

# Rake Tasks via Railtie
# require "snip_snap_zap/railtie" if defined?(Rails)

module SnipSnapZap
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

# Require the delayed jobs
# require "delayed/recurring_job"
require "snip_snap_zap/delayed_jobs/sweeper_job"