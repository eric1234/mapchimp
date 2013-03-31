require 'bundler'
ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym
Dotenv.load

#require 'rack/session/dalli'
#use Rack::Session::Dalli, cache: Dalli::Client.new

get '/' do
  'Request API key'
end
