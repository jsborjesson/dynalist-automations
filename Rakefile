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
  require "./lib/emailer"
  require "dotenv/load"

  Emailer.send_notification
end
