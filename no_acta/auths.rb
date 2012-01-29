module NoACTA
  ##
  # NoACTA Authentication Handlers
  # Now includes:
  #   * Gmail oAuth
  module Authentications

    ##
    # Try a Gmail oAuth login
    def self.try_gmail_login(session)
      session[:oauth] ||= {}  

      request_token = nil
      access_token = nil

      consumer_key = ENV["GMAIL_CONSUMER_KEY"] || "anonymous"
      consumer_secret = ENV["GMAIL_CONSUMER_SECRET"] || "anonymous"
    
      consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret,
        :site => "https://www.google.com",
        :request_token_path => '/accounts/OAuthGetRequestToken?scope=https://mail.google.com/%20https://www.googleapis.com/auth/userinfo%23email',
        :access_token_path => '/accounts/OAuthGetAccessToken',
        :authorize_path => '/accounts/OAuthAuthorizeToken'
      )
    
      if !session[:oauth][:request_token].nil? && !session[:oauth][:request_token_secret].nil?
        request_token = OAuth::RequestToken.new(
          cconsumer, 
          session[:oauth][:request_token],
          session[:oauth][:request_token_secret]
        )
      end
    
      if !session[:oauth][:access_token].nil? && !session[:oauth][:access_token_secret].nil?
        access_token = OAuth::AccessToken.new(
          consumer,
          session[:oauth][:access_token],
          session[:oauth][:access_token_secret]
        )
      end
      
      return consumer, request_token, access_token
    end # try_gmail_login
    
  end # module
end # module
