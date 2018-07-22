# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# every 1.day, at: '10:00 am' do
#   rake 'cron:seckill'
# end

# every 1.day, at: '12:00 am' do
#   runner "SecKill.clean_cache"
# end

require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.cron '55 22 * * *' do
  SecKillJob.perform_now
end

scheduler.cron '10 23 * * *' do
  SecKill.clean_cache
end