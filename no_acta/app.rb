require "bundler"
require "pp" if ENV['RACK_ENV'] != 'production'
Bundler.require()

module NoACTA

  # Load our authentication handlers
  require_relative 'auths.rb'
  require_relative 'db.rb'
  require_relative 'mailers.rb'
  require_relative 'meps.rb'

  class App < Sinatra::Base
    register Sinatra::R18n
    set :root, File.dirname(__FILE__)
    set :sessions, true
    set :views, root + '/views'
    set :translations, root + '/translations'
    set :default_locale, (ENV['ACTA_LOCALE'] || 'ro')

    DB::setup()

    before '/gmail' do
      @consumer,
      @request_token,
      @access_token = Authentications.try_gmail_login(session)
    end

    # Main Page
    get '/' do
      erb :index
    end
    
    # Handle Logout
    get "/logout" do
      session[:oauth] = {}
      redirect "/"
    end

    # If to login with Gmail
    get "/gmail" do
      if @access_token
        response = @access_token.get('https://www.googleapis.com/userinfo/email?alt=json')
        if response.is_a?(Net::HTTPSuccess)
          @email = JSON.parse(response.body)['data']['email']
        else
          STDERR.puts "could not get email: #{response.inspect}"
        end
        erb :gmail
      else
        erb :gmail_login
      end
    end

    # oAuth Gmail Request Handler
    get "/gmail/request" do
      @request_token = @consumer.get_request_token(:oauth_callback => "#{request.scheme}://#{request.host}:#{request.port}/gmail/auth")
      session[:oauth][:request_token] = @request_token.token
      session[:oauth][:request_token_secret] = @request_token.secret
      redirect @request_token.authorize_url
    end

    # oAuth Gmail Authentication Handler
    get "/gmail/auth" do
      @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
      session[:oauth][:access_token] = @access_token.token
      session[:oauth][:access_token_secret] = @access_token.secret
      redirect "/gmail"
    end


    # Gmail email sender
    post "/gmail/send" do
      unless DB::Email.first(:email => params[:email]).nil?
        session[:f_notice] = "Ati mai utilizat aplicatia, de data aceasta nu a fost trimis nici un mail"
        redirect "/"
      end

      if DB::Email.create(:email => params[:email])
        session[:f_notice] = "Ati mai utilizat aplicatia, de data aceasta nu a fost trimis nici un mail"
      else
        session[:f_not_user] = "Ceva a mers prost, mai incercati o data"
        redirect "/"
      end

      Mailers.send_via_gmail(params)
      redirect "/gmail"
    end

  end # class
end # module




