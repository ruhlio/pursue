require 'log4r'
require 'bb-ruby-ext'

class Match
   FIELDS = {
      :mode => 'Mode',
      :map => 'Map',
      :score => 'Final Score',
      :players => 'Players',
      :mvp => 'MVP',
      :league => 'League'
   }

   attr_reader :versus, :mode, :map, :score, :players, :mvp, :league

   def initialize( forum_post )
      @logger = Log4r::Logger.new( Match.name )

      @versus = forum_post[:title]
      parse_message( forum_post[:message] )
   end

   def to_json( *args )
      hash = {}

      hash[:versus] = versus
      FIELDS.keys.each do |var_name|
         hash[var_name] = self.send( var_name )
      end

      hash.to_json( args )
   end

   private

   def parse_message(message)
      FIELDS.each do |var_name, message_key|
         instance_variable_set('@' + var_name.to_s, parse_value(message_key, message))
         self.class.send( :attr_reader, var_name )
      end
   end

   def parse_value(key, message)
      groups = /^\s*#{Regexp.quote(key)}:\s*(.*?)\s*$/.match(message)

      if groups
         groups[1]
      else
         @logger.error("Failed to parse '#{key}' from forum post")
         ""
      end
   end

end
