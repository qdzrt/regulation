namespace :cron do
  desc 'Preferential Rate Seckill'
  task :seckill => :environment do
    SecKillJob.perform_now
  end
end