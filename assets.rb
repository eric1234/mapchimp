class Assets < Sinatra::Base
  set :assets, Sprockets::Environment.new
  settings.assets.append_path 'javascripts'
  settings.assets.append_path 'stylesheets'
  if ENV['RACK_ENV'] == 'production'
    settings.assets.js_compressor = Uglifier.new
    settings.assets.css_compressor = YUI::CssCompressor.new
  end

  get "/:file.js" do
    content_type "application/javascript"
    settings.assets["#{params[:file]}.js"]
  end

  get "/:file.css" do
    content_type "text/css"
    settings.assets["#{params[:file]}.css"]
  end
end
