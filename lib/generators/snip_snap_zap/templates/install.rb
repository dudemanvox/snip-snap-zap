class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :snap_schedules do |t|
      t.string   :schedulable_type
      t.string  :schedulable_id
      t.text     :snipable_attributes
      t.text     :stoppable_attributes
      t.boolean  :active, default: false
      t.datetime :start_at
      t.integer  :frequency_num
      t.string   :frequency_unit

      t.timestamps
    end

    create_table :snip_snaps do |t|
      t.string   :snapable_type
      t.string  :snapable_id
      t.integer  :snap_schedule_id
      t.integer  :version
      t.text     :previous_attributes
      t.text     :modified_attributes

      t.timestamps
    end
  end

end
