require "pony"

class Emailer
  def self.send_notification(body)
    Pony.mail({
      subject: "Dynalist Automator Update",
      body: body,
      to: ENV.fetch("EMAIL_RECEIVER"),
      via: :smtp,
      via_options: {
        address:              'smtp.gmail.com',
        port:                 '587',
        enable_starttls_auto: true,
        user_name:            ENV.fetch("EMAIL_ADDRESS"),
        password:             ENV.fetch("EMAIL_PASSWORD"),
        authentication:       :plain, # :plain, :login, :cram_md5, no auth by default
        domain:               "localhost.localdomain" # the HELO domain provided by the client to the server
      }
    })
  end
end
