require "test_helper"
require "actions/daily_reminder"

class DailyReminderTest < Minitest::Test
  def test_send_daily_reminder
    emailer = MiniTest::Mock.new
    emailer.expect(:send_notification, nil, [String])

    action = DailyReminder.new(
      document: Factory.document,
      notifier: emailer,
      date: Date.new(2018, 7, 22)
    )

    action.execute
    emailer.verify
  end

  def test_dont_send_empty_email
    emailer = :never_called

    action = DailyReminder.new(
      document: Factory.document,
      notifier: emailer,
      date: Date.new(2030, 1, 1)
    )

    action.execute
  end
end
