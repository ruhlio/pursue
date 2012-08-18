require 'match'

describe Match do
   it "parses fields from a properly formatted forum post" do
      match = Match.new(:title => "STD vs THAT", :message => %Q{
Mode: Squad Rush
Map: Metro
Final Score: 4 - 4
Players: Me, him, that other guy
MVP: The Dude
Anything else
         })

      match.versus.should eq("STD vs THAT")
      match.mode.should eq("Squad Rush")
      match.map.should eq("Metro")
      match.score.should eq("4 - 4")
      match.players.should eq("Me, him, that other guy")
      match.mvp.should eq("The Dude")
   end

end
