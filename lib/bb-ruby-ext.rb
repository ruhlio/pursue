require 'bb-ruby'

module BBRuby
   STRIP_REGEX = /\[([^\]]+?)(=[^\]]+?)?\](.+?)\[\/\1\]/

   def self.to_text(bb_code)
      bb_code.gsub(/\[[A-Za-z0-9\/=#]+\]/, '')
   end
end

class String
   def bbcode_to_text
      BBRuby.to_text(self)
   end

   def bbcode_to_text!
      self.replace(BBRuby.to_text(self))
   end
end
