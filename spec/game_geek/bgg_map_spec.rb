require "spec_helper"

RSpec.describe GameGeek::BggMap do
  describe "::Search" do
    describe ".parse" do
      search_results = {"items"=>{"item"=>[{"name"=>{"type"=>"primary", "value"=>"Founders of Gloomhaven"}, "yearpublished"=>{"value"=>"2018"}, "type"=>"boardgame", "id"=>"214032"}, {"name"=>{"type"=>"primary", "value"=>"Gloomhaven"}, "yearpublished"=>{"value"=>"2017"}, "type"=>"boardgame", "id"=>"174430"}, {"name"=>{"type"=>"primary", "value"=>"Gloomhaven: Solo Scenarios"}, "yearpublished"=>{"value"=>"2017"}, "type"=>"boardgame", "id"=>"226868"}, {"name"=>{"type"=>"primary", "value"=>"Gloomhaven: The End of the World (Promo Scenario)"}, "yearpublished"=>{"value"=>"2017"}, "type"=>"boardgame", "id"=>"231934"}], "total"=>"4", "termsofuse"=>"http://boardgamegeek.com/xmlapi/termsofuse"}}
      type = 'boardgame'

      it "parses search results and returns an array of hashes", :aggregate_failures do
        parsed = GameGeek::BggMap::Search.parse(data: search_results,
                                                search_type: type)
        expect(parsed).to be_an_instance_of(Array)
        expect(parsed[0]).to be_an_instance_of(Hash)
        expect(Integer(parsed[0][:id])).to be_a_kind_of(Integer)
        expect(parsed[0][:title]).to be_a_kind_of(String)
        expect(parsed[0][:type]).to eq(type)
      end
    end
  end

  describe "::Thing" do
    board_game_thing = {"items"=>{"item"=>{"thumbnail"=>"https://cf.geekdo-images.com/images/pic2437871_t.jpg", "image"=>"https://cf.geekdo-images.com/images/pic2437871.jpg", "name"=>[{"type"=>"primary", "sortindex"=>"1", "value"=>"Gloomhaven"}, {"type"=>"alternate", "sortindex"=>"1", "value"=>"黯淡港灣"}, {"type"=>"alternate", "sortindex"=>"1", "value"=>"Gloomhaven (second printing)"}], "description"=>"Gloomhaven is a game of Euro-inspired tactical combat in a persistent world of shifting motives. Players will take on the role of a wandering adventurer with their own special set of skills and their own reasons for traveling to this dark corner of the world. Players must work together out of necessity to clear out menacing dungeons and forgotten ruins. In the process, they will enhance their abilities with experience and loot, discover new locations to explore and plunder, and expand an ever-branching story fueled by the decisions they make.&#10;&#10;This is a game with a persistent and changing world that is ideally played over many game sessions. After a scenario, players will make decisions on what to do, which will determine how the story continues, kind of like a &ldquo;Choose Your Own Adventure&rdquo; book. Playing through a scenario is a cooperative affair where players will fight against automated monsters using an innovative card system to determine the order of play and what a player does on their turn.&#10;&#10;Each turn, a player chooses two cards to play out of their hand. The number on the top card determines their initiative for the round. Each card also has a top and bottom power, and when it is a player&rsquo;s turn in the initiative order, they determine whether to use the top power of one card and the bottom power of the other, or vice-versa. Players must be careful, though, because over time they will permanently lose cards from their hands. If they take too long to clear a dungeon, they may end up exhausted and be forced to retreat.&#10;&#10;", "yearpublished"=>{"value"=>"2017"}, "minplayers"=>{"value"=>"1"}, "maxplayers"=>{"value"=>"4"}, "poll"=>[{"results"=>[{"result"=>[{"value"=>"Best", "numvotes"=>"43"}, {"value"=>"Recommended", "numvotes"=>"116"}, {"value"=>"Not Recommended", "numvotes"=>"52"}], "numplayers"=>"1"}, {"result"=>[{"value"=>"Best", "numvotes"=>"67"}, {"value"=>"Recommended", "numvotes"=>"161"}, {"value"=>"Not Recommended", "numvotes"=>"9"}], "numplayers"=>"2"}, {"result"=>[{"value"=>"Best", "numvotes"=>"122"}, {"value"=>"Recommended", "numvotes"=>"103"}, {"value"=>"Not Recommended", "numvotes"=>"6"}], "numplayers"=>"3"}, {"result"=>[{"value"=>"Best", "numvotes"=>"104"}, {"value"=>"Recommended", "numvotes"=>"106"}, {"value"=>"Not Recommended", "numvotes"=>"16"}], "numplayers"=>"4"}, {"result"=>[{"value"=>"Best", "numvotes"=>"1"}, {"value"=>"Recommended", "numvotes"=>"9"}, {"value"=>"Not Recommended", "numvotes"=>"144"}], "numplayers"=>"4+"}], "name"=>"suggested_numplayers", "title"=>"User Suggested Number of Players", "totalvotes"=>"279"}, {"results"=>{"result"=>[{"value"=>"2", "numvotes"=>"1"}, {"value"=>"3", "numvotes"=>"0"}, {"value"=>"4", "numvotes"=>"0"}, {"value"=>"5", "numvotes"=>"0"}, {"value"=>"6", "numvotes"=>"0"}, {"value"=>"8", "numvotes"=>"2"}, {"value"=>"10", "numvotes"=>"11"}, {"value"=>"12", "numvotes"=>"22"}, {"value"=>"14", "numvotes"=>"33"}, {"value"=>"16", "numvotes"=>"7"}, {"value"=>"18", "numvotes"=>"0"}, {"value"=>"21 and up", "numvotes"=>"2"}]}, "name"=>"suggested_playerage", "title"=>"User Suggested Player Age", "totalvotes"=>"78"}, {"results"=>{"result"=>[{"level"=>"1", "value"=>"No necessary in-game text", "numvotes"=>"0"}, {"level"=>"2", "value"=>"Some necessary text - easily memorized or small crib sheet", "numvotes"=>"0"}, {"level"=>"3", "value"=>"Moderate in-game text - needs crib sheet or paste ups", "numvotes"=>"2"}, {"level"=>"4", "value"=>"Extensive use of text - massive conversion needed to be playable", "numvotes"=>"16"}, {"level"=>"5", "value"=>"Unplayable in another language", "numvotes"=>"3"}]}, "name"=>"language_dependence", "title"=>"Language Dependence", "totalvotes"=>"21"}], "playingtime"=>{"value"=>"150"}, "minplaytime"=>{"value"=>"90"}, "maxplaytime"=>{"value"=>"150"}, "minage"=>{"value"=>"12"}, "link"=>[{"type"=>"boardgamecategory", "id"=>"1022", "value"=>"Adventure"}, {"type"=>"boardgamecategory", "id"=>"1020", "value"=>"Exploration"}, {"type"=>"boardgamecategory", "id"=>"1010", "value"=>"Fantasy"}, {"type"=>"boardgamecategory", "id"=>"1046", "value"=>"Fighting"}, {"type"=>"boardgamecategory", "id"=>"1047", "value"=>"Miniatures"}, {"type"=>"boardgamemechanic", "id"=>"2689", "value"=>"Action / Movement Programming"}, {"type"=>"boardgamemechanic", "id"=>"2023", "value"=>"Co-operative Play"}, {"type"=>"boardgamemechanic", "id"=>"2676", "value"=>"Grid Movement"}, {"type"=>"boardgamemechanic", "id"=>"2040", "value"=>"Hand Management"}, {"type"=>"boardgamemechanic", "id"=>"2011", "value"=>"Modular Board"}, {"type"=>"boardgamemechanic", "id"=>"2028", "value"=>"Role Playing"}, {"type"=>"boardgamemechanic", "id"=>"2020", "value"=>"Simultaneous Action Selection"}, {"type"=>"boardgamemechanic", "id"=>"2027", "value"=>"Storytelling"}, {"type"=>"boardgamemechanic", "id"=>"2015", "value"=>"Variable Player Powers"}, {"type"=>"boardgamefamily", "id"=>"24281", "value"=>"Campaign Games"}, {"type"=>"boardgamefamily", "id"=>"25158", "value"=>"Components: Miniatures"}, {"type"=>"boardgamefamily", "id"=>"8374", "value"=>"Crowdfunding: Kickstarter"}, {"type"=>"boardgamefamily", "id"=>"45610", "value"=>"Gloomhaven Universe"}, {"type"=>"boardgamefamily", "id"=>"25404", "value"=>"Legacy"}, {"type"=>"boardgamefamily", "id"=>"5666", "value"=>"Solitaire Games"}, {"type"=>"boardgameexpansion", "id"=>"226868", "value"=>"Gloomhaven: Solo Scenarios"}, {"type"=>"boardgameexpansion", "id"=>"231934", "value"=>"Gloomhaven: The End of the World (Promo Scenario)"}, {"type"=>"boardgamedesigner", "id"=>"69802", "value"=>"Isaac Childres"}, {"type"=>"boardgameartist", "id"=>"77084", "value"=>"Alexandr Elichev"}, {"type"=>"boardgameartist", "id"=>"78961", "value"=>"Josh T. McDowell"}, {"type"=>"boardgameartist", "id"=>"84269", "value"=>"Alvaro Nebot"}, {"type"=>"boardgamepublisher", "id"=>"27425", "value"=>"Cephalofair Games"}, {"type"=>"boardgamepublisher", "id"=>"18852", "value"=>"Hobby World"}], "type"=>"boardgame", "id"=>"174430"}, "termsofuse"=>"http://boardgamegeek.com/xmlapi/termsofuse"}}

    describe "::Helpers" do
      describe ".extract_names_by_type" do
        it "returns a string for name types with one instance" do
          primary_name = GameGeek::BggMap::Thing::Helpers.extract_names_by_type(board_game_thing, 'primary')
          expect(primary_name).to eq("Gloomhaven")
        end

        it "returns an array of strings for name types with multiple instances" do
          alternate_names = GameGeek::BggMap::Thing::Helpers.extract_names_by_type(board_game_thing, 'alternate')
          expect(alternate_names).to be_an_instance_of(Array)
          expect(alternate_names[0]).to be_a_kind_of(String)
        end
      end

      describe ".extract_link_values_by_type" do
        it "returns an array of strings of the requested values" do
          mechanics = GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(board_game_thing, 'boardgamemechanic')
          expect(mechanics).to be_an_instance_of(Array)
          expect(mechanics[0]).to be_a_kind_of(String)
        end

        it "raises an error if it receives an invalid type" do
          expect(GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(board_game_thing, 'foobar')).to raise_error("Link type is invalid")
        end
      end
    end
  end
end