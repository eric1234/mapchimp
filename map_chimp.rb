class MapChimp < Sinatra::Base

  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']

  get '/' do
    erb :form
  end

  post '/' do
    session[:api_key] = params[:api_key]
    session[:list_id] = params[:list_id]
    redirect to('/map')
  end

  get '/map' do
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
    erb :map
  end
end
