require "date"
require "./lib/emailer"

class DailyReminders
  attr_reader :document, :notifier, :date
  private :document, :notifier, :date

  def initialize(document:, notifier: Emailer, date: Date.today)
    @document = document
    @notifier = notifier
    @date     = date
  end

  def execute
    bullets = document.bullets_with_date(date)

    html = <<~HTML
    <ul>
    #{bullets.map(&:to_html).join.strip}
    </ul>
    HTML

    notifier.send_notification(html)
  end
end
