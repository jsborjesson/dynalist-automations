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

  require "./lib/document"
  require "./lib/dynalist"
  require "./lib/emailer"
  require "./lib/actions/daily_reminders"

  file_id = ENV.fetch("DAILY_REMINDER_DOCUMENT")
  document = Document.from_json(
    file_id,
    Dynalist.new.document(file_id),
  )

  action = DailyReminders.new(
    document: document,
    notifier: Emailer,
    date: Date.today
  )

  action.execute
end
