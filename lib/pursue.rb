require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/config_file'
require 'json'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
require 'log4r/outputter/consoleoutputters'

require 'xenforo'
require 'match'

class Pursue < Sinatra::Base
   register Sinatra::ConfigFile

   enable :logging
   config_file "#{Dir.pwd}/settings.yaml"

   configure do
      Log4r::YamlConfigurator.load_yaml_file('log4r.yaml')
   end

   before do
   end

   after do
   end

   get '/' do
      "It's #{Time.now}"
   end

   get '/news' do
      content_type :json

      node_id = settings.news_forum_node_id
      news = XenForo.get_threads( node_id, 10 )

      news.to_json
   end

   get '/matches' do
      content_type :json
   end

   post '/apply' do
      #node_id = settings.apply_forum_node_id

   end

end
