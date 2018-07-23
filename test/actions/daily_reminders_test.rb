require "test_helper"
require "actions/daily_reminders"

class DailyRemindersTest < Minitest::Test
  def test_send_daily_reminder
    expected_email_body = <<~HTML
      <ul>
      <a href="https://dynalist.io/d/file_id#z=Qp5qIiccr1XuAP6rJL5RX_jt">
        <li>
          <div><b>Bullet 2 !(2018-07-22 15:00)</b></div>
          <div><i></i></div>
        </li>
      </a>
      <a href="https://dynalist.io/d/file_id#z=xbexUA6PK1ZJ7yHk1UMPbCcv">
        <li>
          <div><b>Bullet 4</b></div>
          <div><i>!(2018-07-22)</i></div>
        </li>
      </a>
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
