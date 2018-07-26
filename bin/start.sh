#!/usr/bin/env bash

if [[ $RAILS_ENV == 'production' ]]; then
    bundle exec rake assets:precompile
fi

bundle exec whenever -i
bundle exec pumactl start
bundle exec sidekiq -C config/sidekiq.yml -d
