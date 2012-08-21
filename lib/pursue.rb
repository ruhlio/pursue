require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/config_file'
require 'json'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/fileoutputter'
require 'log4r/outputter/consoleoutputters'

require 'debugger'

require 'xenforo'
require 'match'

class Pursue < Sinatra::Base
   register Sinatra::ConfigFile

   config_file "#{Dir.pwd}/settings.yaml"

   configure do
      Log4r::YamlConfigurator.load_yaml_file('log4r.yaml')

      disable :logging
      logger = Log4r::Logger.new( Pursue.name )
      use Rack::CommonLogger, logger
   end

   before do
      content_type :json
   end

   after do
   end

   get '/news' do
      node_id = settings.node_id['news_forum']
      news = XenForo.get_threads( node_id, :max => 10 )

      news.to_json
   end

   get '/matches' do
      matches = []

      node_id = settings.node_id['matches_forum']
      XenForo.get_threads( node_id ).each do |post|
         matches << Match.new( post )
      end

      matches.to_json
   end

   post '/apply' do
      #node_id = settings.apply_forum_node_id

   end

end
