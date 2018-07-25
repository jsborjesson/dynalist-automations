require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

task default: :test

desc "Send daily notification"
task :send_notification do
  require "dotenv/load"

  require "./lib/dynalist"
  require "./lib/actions/daily_reminder"

  file_id  = ENV.fetch("DAILY_REMINDER_DOCUMENT")
  document = Dynalist.new.document(file_id)
  action   = DailyReminder.new(document: document)

  action.execute
end
