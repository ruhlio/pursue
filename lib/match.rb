require 'log4r'

class Match
   FIELDS = {
      :mode => 'Mode',
      :map => 'Map',
      :score => 'Final Score',
      :players => 'Players',
      :mvp => 'MVP'
   }

   @logger = Log4r::Logger.new(Match.name)
   attr_reader :versus, :mode, :map, :score, :players, :mvp

   def initialize( forum_post )
      @versus = forum_post[:title]

      message = forum_post[:message]
      parse_message(message)
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
         ""
         @logger.error()
      end
   end

end
