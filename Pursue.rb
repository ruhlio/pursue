require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/config_file'
require 'json'

require './Models'

class Pursue < Sinatra::Base
   register Sinatra::ConfigFile

   config_file 'config.yml'

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

   post '/apply' do
      #node_id = settings.apply_forum_node_id

   end

end
