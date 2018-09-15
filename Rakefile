require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

task default: :test

desc "Require dependencies"
task :env do
  require "dotenv/load"

  require "./lib/dynalist"
  require "./lib/actions/daily_reminder"
  require "./lib/actions/sort"
end

desc "Sort stuff"
task :sort => :env do
  file_id  = ENV.fetch("MAIN_DOCUMENT")
  api = Dynalist.new
  document = api.document(file_id)
  action   = Sort.new(document: document, api: api)

  action.execute
end

desc "Send daily notification"
task :send_notification => :env do
  file_id  = ENV.fetch("MAIN_DOCUMENT")
  api = Dynalist.new
  document = api.document(file_id)
  action   = DailyReminder.new(document: document)

  action.execute
end

desc "Perform all actions"
task :action => [:sort, :send_notification]
