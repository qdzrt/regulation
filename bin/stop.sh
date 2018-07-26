#!/usr/bin/env bash

bundle exec whenever -c
bundle exec pumactl stop
bundle exec sidekiqctl stop tmp/pids/sidekiq.pid