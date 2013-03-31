class MapChimp < Sinatra::Base

  use Rack::SslEnforcer if ENV['RACK_ENV'] == 'production'
  set :session_secret, ENV['SESSION_SECRET']
  use Rack::Session::Cookie, secret: settings.session_secret

  get '/' do
    erb :form
  end

  post '/' do
    session[:api_key] = params[:api_key]
    session[:list_id] = params[:list_id]
    redirect to('/map')
  end

  get '/map' do
    begin
      mailchimp = GibbonExport.new session[:api_key]
      list = mailchimp.list id: session[:list_id]
      idx  = 0
      headers = JSON.parse list.next
      @subscribers = []
      while subscriber = JSON.parse(list.next) rescue nil
        subscriber = Hash[*headers.zip(subscriber).flatten]
        next if subscriber['LATITUDE'].nil? || subscriber['LONGITUDE'].nil?
        subscriber.each do |key, value|
          subscriber.delete key if
            key =~ /^[A-Z_]+$/ &&
            key != 'LONGITUDE' &&
            key != 'LATITUDE'
        end
        @subscribers << subscriber
      end
      @fullscreen = true
      erb :map
    rescue Gibbon::MailChimpError, SocketError
      redirect to('/?invalid=true')
    end
  end
end
