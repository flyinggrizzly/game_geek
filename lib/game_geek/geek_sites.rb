require 'httparty'
require 'nokogiri'

class GeekSite
  include HTTParty

  class << self
    base_uri = 'https://www.boardgamegeek.com/xmlapi2'.freeze

    def search_games
    end

    private

    # Searches
    def search_by_type(query, type)
      results = []
      unless %w[boardgame,
                boardgamedesigner,
                rpg,
                rpgdesigner,
                videogame,
                videogamedesigner].include? type
        raise 'Invalid search type'
      end

      request = HTTParty.get("#{base_uri}/search?query=#{query}&type=#{type}").parsed_response
      request['items']['item'].each do |game|
        results << { id: game['id'], title: game['name']['value'] }
      end
      results
    end

    def retrieve_bgg_item_data(bgg_id, type)
      unless %w[boardgame,
                rpgitem,
                rpgissue,
                videogame].include? type
        raise 'Invalid item type'
      end

      request = HTTParty.get("#{base_uri}/thing?id=#{bgg_id}&type=#{type}").parsed_response

      {
        # Return this hash
      }

    end
  end
end