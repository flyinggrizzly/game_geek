require "spec_helper"

RSpec.describe GameGeek::BggMap do
  describe "::Search" do
    describe ".parse" do
      search_results = JSON.parse(File.read('spec/support/files/httparty_boardgame_search_result.json')).to_h
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
    board_game_thing = JSON.parse(File.read('spec/support/files/httparty_boardgame_retrieval_result.json')).to_h

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
          expect { GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(board_game_thing, 'not_a_known_type') }.to \
            raise_error("Link type is invalid")
        end
      end
    end
  end
end