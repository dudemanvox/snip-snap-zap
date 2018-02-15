namespace :snipsnap do |t, args|
  desc "schedule [type, id, active, run_at, *attributes_as_symbols] Schedule a job to be run by the gem."
  task :schedule, [:type, :id, :active, :run_at, :run_every] => :environment do |t, args|
    # Attributes are listed in args.extras. Skip everything unless we have been given attributes.
    if args.extras.blank?
      puts("Please provide a list of attributes as the final argument! ie. ...,:id,:name,:status")
      next
    end

    # Isolate the stoppable attributes
    stoppable_attrs = Hash[args.extras.select{|a| a.match(/\=\>/i)}.map{|s| s.split('=>')}.map{|a| [to_symbol(a.first), a.second]}]
    # Remove them from the args
    snipable_attrs = args.extras.reject{|a| a.match(/\=\>/i)}

    unless stoppable_attrs.present?
      stoppable_attrs = nil
    end

    # Merge the extra attributes into a hash and reinstanciate the args object.
    options = {}.merge!(args.to_h).merge!(attributes: snipable_attrs.map{|a| to_symbol(a)})

    args = Rake::TaskArguments.new(options.keys, options.values)

    # Fail out if we can't find the legit object.
    next unless object = check_object(args.type, args.id)
    
    new_record = false

    show_me = {schedulable_type: object.class.name, schedulable_id: object.send( object.class.primary_key ), snipable_attributes: args.attributes, stoppable_attributes: [stoppable_attrs], active: args.active, start_at: args.run_at, frequency_num: parse_duration(args.run_every).first, frequency_unit: parse_duration(args.run_every).last}
    puts show_me.inspect

    # Attempt to create the new schedule in the DB and return a success/failure message.
    if new_schedule = SnipSnapZap::SnapSchedule.where(show_me).first_or_create do |s|
        new_record = true
        puts "Successfully created #{s.class} #{s.id}!"
        puts s.inspect
      end
      unless new_record
        puts "This schedule already exists!\n"
        puts new_schedule.inspect
        puts "Exiting..."
      end
    else
      puts "Failed to create #{new_schedule.class} due to errors! #{new_schedule.errors.full_messages}!"
    end
  end

  desc "Start the sweeper job."
  task :start => :environment do |t, args|
    SnipSnapZap::DelayedJobs::SweeperJob.schedule!
    puts "Sweeper has been scheduled!"
  end
end

# Remove : and convert to symbol.
def to_symbol(text)
  text.gsub(/\:/i, '').to_sym
end

# Find the object in the DB. Error gracefully.
def check_object(type, id)
  begin
    object = type.constantize.find(id)
    puts "Found #{type} #{id}!"
    return object
  rescue ActiveRecord::RecordNotFound => e
    puts e.message
    puts "Exiting..."
  end
end

# Split the string for storage.
def parse_duration(string)
  string.split(".")
end