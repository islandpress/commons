require_relative 'config/application'

Rails.application.load_tasks

task(:default).clear
task default: %w(rubocop spec)
