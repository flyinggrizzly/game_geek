require 'httparty'
require 'nokogiri'
require_relative 'bgg_map'

module GameGeek
  module API
    extend self

    API_2_ORIGIN  = 'https://www.boardgamegeek.com/xmlapi2'.freeze
    API_1_ORIGIN  = 'https://www.boardgamegeek.com/xmlapi'.freeze
    GEEK_THINGS   = %w[boardgame \
                       boardgamedesigner \
                       rpgitem \
                       rpgdesigner \
                       videogame \
                       videogamedesigner].freeze

    # Searches the API, specifying only boardgame results should be returned
    def search_boardgames(query)
      raise 'Search query must not be empty' if query.to_s.empty?
      search_by_type(query, 'boardgame')
    end

    # Retrieves data on a boardgame, returning a parsed hash. Optionally
    # will return the original XML response from the API
    def get_boardgame(bgg_id:, include_original_response: false)
      raise 'BGG ID is required' unless bgg_id
      retrieve_bgg_item_data(bgg_id, 'boardgame', include_original_response)
    end

    # Searches the API, specifying only rpg results should be returned
    def search_rpgs(query)
      search_by_type(query, 'rpgitem')
    end

    def get_rpg(bgg_id:, include_original_response: false)
      raise 'BGG ID is required' unless bgg_id
      retrieve_bgg_item_data(bgg_id, 'rpgitem', include_original_response)
    end

    # Searches the API, specifying only videogame results should be returned
    def search_videogames(query)
      search_by_type(query, 'videogame')
    end

    # Retrieves ratings and comments for a BGG resource
    def retrieve_bgg_item_ratings(bgg_id)
      # "API_ORIGIN /thing?id=#{bgg_id}&ratingcomments=1"
    end

    private

    # Searches
    def search_by_type(query, type)
      raise 'Invalid search type' unless GEEK_THINGS.include? type

      request = HTTParty.get("#{API_2_ORIGIN}/search?query=#{query}&type=#{type}")
      raise 'Board Game Geek is not available' unless request.success?
      parsed_request = request.parsed_response
      GameGeek::BggMap::Search.parse(data: parsed_request, search_type: type)
    end

    # Retrieves data on a particular item from the API
    def retrieve_bgg_item_data(bgg_id, type, include_original_response = false)
      raise 'Invalid item type' unless GEEK_THINGS.include? type

      response      = HTTParty.get("#{API_2_ORIGIN }/thing?id=#{bgg_id}&type=#{type}")
      response_data = response.parsed_response

      mapped = {}
      if type.eql?('boardgame')
        mapped = GameGeek::BggMap::Thing::BoardgameMap.parse(data: response_data, bgg_id: bgg_id)
      elsif type.eql?('rpgitem')
        mapped = GameGeek::BggMap::Thing::RpgMap.parse(data: response_data, bgg_id: bgg_id)
      end

      mapped[:response_body] = response.body if include_original_response
      mapped
    end
  end
end