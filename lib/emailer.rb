require "pony"

class Emailer
  def self.send_notification(body, subject = "Dynalist Automator Update")
    Pony.mail({
      subject: subject,
      body: body,
      to: ENV.fetch("EMAIL_RECEIVER"),
      via: :smtp,
      via_options: {
        address:              'smtp.gmail.com',
        port:                 '587',
        enable_starttls_auto: true,
        user_name:            ENV.fetch("EMAIL_ADDRESS"),
        password:             ENV.fetch("EMAIL_PASSWORD"),
        authentication:       :plain,
        domain:               "localhost.localdomain"
      }
    })
  end
end
