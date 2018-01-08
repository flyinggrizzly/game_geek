require 'httparty'
require 'nokogiri'

class GeekSite
  include HTTParty

  class << self
    API_2_ORIGIN  = 'https://www.boardgamegeek.com/xmlapi2'.freeze
    API_1_ORIGIN  = 'https://www.boardgamegeek.com/xmlapi'.freeze
    GEEK_THINGS   = %w[boardgame \
                       boardgamedesigner \
                       rpg \
                       rpgdesigner \
                       videogame \
                       videogamedesigner].freeze

    def search_boardgames(query)
      search_by_type(query, 'boardgame')
    end

    def search_rpgs(query)
      search_by_type(query, 'rpg')
    end

    def search_videogames(query)
      search_by_type(query, 'videogame')
    end

    private

    # Searches
    def search_by_type(query, type)
      results = []
      unless GEEK_THINGS.include? type
        raise 'Invalid search type'
      end

      request = HTTParty.get("#{API_2_ORIGIN }/search?query=#{query}&type=#{type}").parsed_response
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

      request = HTTParty.get("#{API_2_ORIGIN }/thing?id=#{bgg_id}&type=#{type}").parsed_response

      {
        # Return this hash
      }

    end

    def retrieve_bgg_item_ratings(bgg_id)
      # "API_ORIGIN /thing?id=#{bgg_id}&ratingcomments=1"
    end
  end
end