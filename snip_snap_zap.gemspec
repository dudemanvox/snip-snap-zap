
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "snip_snap_zap/version"

Gem::Specification.new do |spec|
  spec.name          = "snip_snap_zap"
  spec.version       = SnipSnapZap::VERSION
  spec.authors       = ["Tommy Bregar"]
  spec.email         = ["tommybregar@gmail.com"]

  spec.summary       = %q{Schedule snapshots of your models as they exist in the database.}
  spec.description   = %q{Using recurring delayed jobs take scheduled snapshots of your models. Filter down to the attributes and associations which matter to you.}
  spec.homepage      = "https://github.com/dudemanvox/snip-snap-zap"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  # spec.add_development_dependency "rails", "~> 4.2.7.1"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "delayed_job_recurring"

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
