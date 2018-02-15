module SnipSnapZap
  class Configuration
    attr_accessor :queue_name, :run_every,
                  :run_at, :timezone

    def initialize
      @queue_name = nil
      @run_every = nil
      @run_at = nil
      @timezone = nil
    end
  end
end