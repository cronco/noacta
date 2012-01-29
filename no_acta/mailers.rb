module NoACTA

  ##
  # NoACTA Mailers
  module Mailers
    ##
    # Send through gmail
    def self.send_via_gmail(args)
      email   = args[:email]
      name    = args[:name]
      token   = args[:token]
      token_secret  = args[:secret]
      # Pre-create connection
      secret = {
        :consumer_key => 'anonymous',
        :consumer_secret => 'anonymous',
        :token => token,
        :token_secret => token_secret
      }
      smtp_conn = Net::SMTP.new('smtp.gmail.com', 587)
      smtp_conn.enable_starttls_auto
      smtp_conn.start('gmail.com', email, secret, :xoauth)

      # Pre-create mail
      mail = Mail.new do
        from      "#{name} <#{email}>"
        subject   R18n.get.t.email.subject
        bcc       MEPS.get().join(',')
        text_part do
          content_type  'text/plain; charset=utf-8'
          body          R18n.get.t.email.body + name
        end
      end

      # Deliver method
      mail.delivery_method :smtp_connection, {:connection => smtp_conn}
      return mail.deliver
    end
  end #module
end #module
