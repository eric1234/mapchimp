require 'bundler'
ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym
Dotenv.load if ENV['RACK_ENV'] == 'development'

require './assets'
require './map_chimp'

map('/assets') {run Assets}
run MapChimp
