# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
# https://github.com/puma/puma/blob/master/examples/config.rb
require 'dotenv'

app_dir = File.expand_path("../..", __FILE__)

Dotenv.load("#{app_dir}/.env")

work_env = ENV.fetch("RAILS_ENV") { "development" }

min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { 1 }
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment work_env

daemonize work_env == 'production'

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch("WEB_CONCURRENCY") { 1 }

bind "unix://#{app_dir}/tmp/sockets/puma.sock"
pidfile File.join(app_dir,'/tmp/pids/puma.pid')
state_path File.join(app_dir,'/tmp/pids/puma.state')
activate_control_app "unix://#{app_dir}/tmp/sockets/pumactl.sock"
stdout_redirect "#{app_dir}/log/puma_access.log", "#{app_dir}/log/puma_error.log"

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
preload_app!

before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  if defined?(ActiveRecord)
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
