require "test_helper"
require "actions/daily_reminders"

class DailyRemindersTest < Minitest::Test
  def test_send_daily_reminder
    expected_email_body = <<~HTML
      <ul>
      <li>
        Bullet 2 !(2018-07-22 15:00)<br/>
        <small></small>
      </li>
      <li>
        Bullet 4<br/>
        <small>!(2018-07-22)</small>
      </li>
      </ul>
    HTML
    document = Document.from_json("file_id", Factory.document_response)
    emailer = MiniTest::Mock.new
    emailer.expect(:send_notification, nil, [expected_email_body])
    action = DailyReminders.new(
      document: document,
      notifier: emailer,
      date: Date.new(2018, 7, 22)
    )

    action.execute

    emailer.verify
  end
end
