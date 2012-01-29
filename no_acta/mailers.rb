##
# NoACTA Mailers

module NoACTA

  ##
  # Send through gmail
  def send_via_gmail(args)
    email   = args[:email]
    name    = args[:name]
    token   = args[:token]
    secret  = args[:secret]
    # Pre-create connection
    secret = {
      :consumer_key => 'anonymous',
      :consumer_secret => 'anonymous',
      :token => token,
      :token_secret => secret
    }
    smtp_conn = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls_auto

    # Pre-create mail
    mail = Mail.new do
      from      "#{name} <#{email}>\n"
      subject   t.email.subject
      body      t.email.body + "\n#{args[:name]}"
      bcc       meps.join(',')
    end

    # Deliver method
    mail.delivery_method :smtp_connection, { 
      :connection => smtp_connection.start(
        'gmail.com',
        args[:email],
        secret,
        :xoauth
      )
    }
    mail.deliver

  end
end #module