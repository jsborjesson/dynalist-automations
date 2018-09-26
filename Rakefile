require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

task default: :test

# Set up logging
require "logger"
LOGGER = Logger.new(STDOUT)

desc "Perform all actions"
task :action => ["actions:repeat", "actions:sort", "actions:send_notification"]

namespace :actions do
  desc "Require dependencies"
  task :env do
    LOGGER.info("Running 'env' action")

    require "dotenv/load"

    require "./lib/dynalist"
    require "./lib/actions/daily_reminder"
    require "./lib/actions/sort"
    require "./lib/actions/repeat"

    @file_id  = ENV.fetch("MAIN_DOCUMENT")
    @api      = Dynalist.new(logger: LOGGER)
    @document = @api.document(@file_id)
  end

  desc "Sort stuff"
  task :sort => :env do
    LOGGER.info("Running 'sort' action")
    action = Sort.new(document: @document, api: @api)
    action.execute
  end

  desc "Send daily notification"
  task :repeat => :env do
    LOGGER.info("Running 'repeat' action")
    action = Repeat.new(document: @document, api: @api)
    action.execute
  end

  desc "Send daily notification"
  task :send_notification => :env do
    LOGGER.info("Running 'send_notification' action")
    action = DailyReminder.new(document: @document)
    action.execute
  end
end
