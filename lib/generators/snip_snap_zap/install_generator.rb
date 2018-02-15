require 'rails/generators'
require 'rails/generators/migration'
require 'active_record'
require 'rails/generators/active_record'
require 'generators/snip_snap_zap/migration_generator'

module SnipSnapZap
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend SnipSnapZap::Generators::MigrationGenerator

      source_root File.expand_path("../templates", __FILE__)

      def copy_migration
        migration_template 'install.rb', 'db/migrate/install_snip_snap_zap.rb'
      end
    end
  end
end