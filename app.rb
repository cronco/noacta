# encoding: utf-8

require "rubygems"
require "sinatra"
require 'json'
require "oauth"
require "oauth/consumer"
require 'haml'
require "gmail_xoauth"
require "data_mapper"

enable :sessions

# Setting up the database
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/mydatabase.db")

euro = ['elena.basescu@europarl.europa.eu', 'theodordumitru.stolojan@europarl.europa.eu',
        'monica.macovei@europarl.europa.eu', 'traian.ungureanu@europarl.europa.eu',
        'cristiandan.preda@europarl.europa.eu', 'marian-jean.marinescu@europarl.europa.eu',
        'iosif.matula@europarl.europa.eu', 'sebastianvalentin.bodu@europarl.europa.eu', 
        'petru.luhan@europarl.europa.eu', 'rares-lucian.niculescu@europarl.europa.eu',
        'oana.antonescu@europarl.europa.eu','adrian.severin@europarl.europa.eu',
        'rovana.plumb@europarl.europa.eu', 'ioanmircea.pascu@europarl.europa.eu',
        'silviaadriana.ticau@europarl.europa.eu', 'dacianaoctavia.sarbu@europarl.europa.eu',
        'corina.cretu@europarl.europa.eu', 'victor.bostinaru@europarl.europa.eu',
        'georgesabin.cutas@europarl.europa.eu', 'catalin-sorin.ivan@europarl.europa.eu',
        'ioan.enciu@europarl.europa.eu', 'norica.nicolai@europarl.europa.eu', 
        'adinaioana.valean@europarl.europa.eu', 'adinaioana.valean@europarl.europa.eu', 
        'renate.weber@europarl.europa.eu', 'ramonanicole.manescu@europarl.europa.eu',
        'cristiansilviu.busoi@europarl.europa.eu', 'tudorcorneliu.vadim@europarl.europa.eu',
        'george.becali@europarl.europa.eu', 'laszlo.tokes@europarl.europa.eu', 
        'iuliu.winkler@europarl.europa.eu', 'csaba.sogor@europarl.europa.eu', 
        'vasilicaviorica.dancila@europarl.europa.eu']

email = "Subject: Cerere ACTA

Stimate domn/doamnă deputat în Parlamentul European,
 
Prin prezenta vă informez, ca cetățean al României și ca cetățean al Uniunii Europene, de opțiunea mea în legătură cu Tratatul Comercial Anti-Contrafacere (ACTA – Anti-Counterfeiting Trade Agreement).
 
Acest tratat, va avea ca efect distrugerea drepturilor mele și a concetățenilor mei români și europeni de a accesa Internetul și de a schimba liber informații și opinii.
Menționez că sunt de asemenea împotriva deciziei Consiliului Uniunii Europene din 28 septembrie 2008 care susține acest proiect.
Drepturile mele la libera exprimare precum și drepturile mele fundamentale vor fi puternic restrânse și, dacă ACTA va fi adoptată de
Parlamentul European, chiar și drepturile dumneavoastră din punct de vedere politic și social vor putea fi încălcate din cauza acestui Tratat. 
- ISP-urile (furnizorii de servicii internet) vor fi responsabili din punct de vedere legal pentru ceea ce fac utilizatorii lor pe Internet,
 obligați să acționeze ca o veritabilă Securitate Comunistă (după modelul sistemului de cenzură comunist din China)
- Medicamente generice care ar putea salva vieți ar putea fi interzise.
- Interesele deţinătorilor de drepturi de proprietate intelectuală sunt puse mai presus de libertatea de exprimare, viaţa privată şi alte drepturi
fundamentale.
- Prevederile din versiunea finală a Acordului, al căror înţeles nu va fi clarificat  înainte de ratificarea ACTA, sunt vagi şi riscă să fie interpretate în moduri care ar
putea permite incriminarea unui număr mare de cetăţeni, pentru delicte triviale.
Modalitatea în care s-a realizat negocierea Acordului îl privează de credibilitate democratică şi de claritate juridică.
Dacă va fi ratificat, Acordul va avea implicaţii majore pentru libertatea de exprimare, accesul la cultură şi viaţa privată, va afecta comerţul internaţional şi va reprezenta un obstacol în calea inovării.[1]
Deși văd necesară apărarea drepturilor de autor, nu pot fi de acord cu posibilitatea încălcării drepturilor fundamentale și libertatile cetățenești ale cetățenilor români și europeni, așa cum sunt ele stabilite de Tratatul de la Lisabona, Carta Drepturilor Fundamentala a Uniunii Europene, Tratatele Uniunii Europene și Constituția României.
 
Având în vedere asta și faptul că probabil doriți să participați și la următoarele alegeri pentru Parlamentul European vă solicit expres să nu susțineti aceast proiect de Tratat.
 
 Cu considerație,
 %s\n
"

link = "[1] http://www.apti.ro/sites/default/files/De%20ce%20este%20ACTA%20un%20acord%20controversat.pdf\n"

class Email
  include DataMapper::Resource
  property :id,		   Serial
  property :email,         String
end

before do
  session[:oauth] ||= {}  
  
  consumer_key = ENV["CONSUMER_KEY"] || ENV["consumer_key"] || "anonymous"
  consumer_secret = ENV["CONSUMER_SECRET"] || ENV["consumer_secret"] || "anonymous"
  
  @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret,
    :site => "https://www.google.com",
    :request_token_path => '/accounts/OAuthGetRequestToken?scope=https://mail.google.com/%20https://www.googleapis.com/auth/userinfo%23email',
    :access_token_path => '/accounts/OAuthGetAccessToken',
    :authorize_path => '/accounts/OAuthAuthorizeToken'
  )
  
  if !session[:oauth][:request_token].nil? && !session[:oauth][:request_token_secret].nil?
    @request_token = OAuth::RequestToken.new(@consumer, session[:oauth][:request_token], session[:oauth][:request_token_secret])
  end
  
  if !session[:oauth][:access_token].nil? && !session[:oauth][:access_token_secret].nil?
    @access_token = OAuth::AccessToken.new(@consumer, session[:oauth][:access_token], session[:oauth][:access_token_secret])
  end
  
end

get "/" do
  if @access_token
    response = @access_token.get('https://www.googleapis.com/userinfo/email?alt=json')
    if response.is_a?(Net::HTTPSuccess)
      @email = JSON.parse(response.body)['data']['email']
    else
      STDERR.puts "could not get email: #{response.inspect}"
    end
    haml :index
  else
    '<a href="/request">Sign On</a>'
  end
end

post "/sendmail" do
  
  unless Email.first(:email => params[:email]).nil?
    session[:f_notice] = "Ati mai utilizat aplicatia, de data aceasta nu a fost trimis nici un mail"
    redirect "/"
  end

  Email.create(:email => params[:email])

  smtp = Net::SMTP.new('smtp.gmail.com', 587)
  smtp.enable_starttls_auto
  secret = {
    :consumer_key => 'anonymous',
    :consumer_secret => 'anonymous',
    :token => params[:token],
    :token_secret => params[:secret] 
  }
  head = "From: %s <%s>\n" % [params[:name], params[:email]]
  email = email % params[:name]
  euro.each do |e|
    sleep 3
    smtp.start('gmail.com', params[:email], secret, :xoauth) do |smtp| 
      smtp.send_message head + ("To: %s\n" % e) + email + link, params[:email], e
    end
    print e
  end
  smtp.finish
  redirect "/"
end

get "/request" do
  @request_token = @consumer.get_request_token(:oauth_callback => "#{request.scheme}://#{request.host}:#{request.port}/auth")
  session[:oauth][:request_token] = @request_token.token
  session[:oauth][:request_token_secret] = @request_token.secret
  redirect @request_token.authorize_url
end

get "/auth" do
  @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
  session[:oauth][:access_token] = @access_token.token
  session[:oauth][:access_token_secret] = @access_token.secret
  redirect "/"
end

get "/logout" do
  session[:oauth] = {}
  redirect "/"
end

DataMapper.auto_upgrade!
