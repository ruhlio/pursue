require 'ramaze'
require 'json'
require 'yaml'
require 'log4r'

require 'models/xenforo'
require 'models/match'

class Pursue < Ramaze::Controller
   map '/api'

   provide( :json, :type => 'application/json' ) do |action, value|
      value.to_json
   end

   def initialize
      super

      @logger = Log4r::Logger.new( Pursue.name )
      @xenforo = XenForo.new( @@settings['xenforo']['connection_string'] )
   end

   def news
      node_id = @@settings['xenforo']['node_id']['news_forum']
      @xenforo.get_threads( node_id, :max => 10, :bbcode => :render )
   end

   def matches
      matches = []

      node_id = @@settings['xenforo']['node_id']['matches_forum']
      @xenforo.get_threads( node_id, :bbcode => :strip ).each do |post|
         matches << Match.new( post )
      end

      matches
   end

   def roster
      member_groups = @@settings['xenforo']['member_groups']
      @xenforo.get_user_profiles( member_groups )
   end

   def apply
      #node_id = settings.apply_forum_node_id

   end

end
