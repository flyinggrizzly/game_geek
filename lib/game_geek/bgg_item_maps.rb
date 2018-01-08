# Isolate knowledge of BGG's API response structures,
# and more specifically HTTParty's parsing of them,
# into a module for maintenance and decoupling.
module BGGItemMaps

  # Share parsing methods for BGG Items' data structures.
  module Helpers
    extend self

    # Given the items['item'] attribute produced by HTTParty from a BGG API
    # XML response as data, and a type of name to extract, returns either a
    # string for the primary name, or an array of strings of alternate names.
    def extract_names_by_type(data, type)
      names = data['name'].select { |name| name['type'] == type }
      return nil if names.empty?

      # Return a string if there is one name, or array of strings
      if names.length.eql?(1)
        return names.first['value']
      else
        return names.map { |name| name['value'] }
      end
    end

    # Given a JSON array of link attributes produced by HTTParty from a BGG API
    # XML response, and a desired type, returns a string array of the values of
    # those link attributes.
    def extract_link_values_by_type(links, link_type)
      links_of_type = links.select { |link| link['type'].eql?(link_type) }
      links_of_type.map { |link| link['value'] }
    end
  end


  # Datamap for BGG API's boardgame items.
  # Does not yet return BGG's suggested number of players, or 
  # suggested age.
  module BoardgameMap
    extend self

    def parse(data:, bgg_id:)
      {
        bgg_id:           bgg_id,
        name:             BGGItemMaps::Helpers.extract_names_by_type(data, 'primary'),
        alternate_names:  BGGItemMaps::Helpers.extract_names_by_type(data, 'alternate'),
        description:      data['description'],
        year_published:   data['yearpublished']['value'],
        min_players:      data['minplayers']['value'],
        max_players:      data['maxplayers']['value'],
        # suggested_num_players: TODO: work out how this is calculated
        playing_time:     data['playingtime']['value'],
        min_playing_time: data['minplaytime']['value'],
        max_playing_time: data['maxplaytime']['value'],
        min_age:          data['minage']['value'],
        # suggested_age: TODO: work out how this is calculated
        categories:       BGGItemMaps::Helpers.extract_link_values_by_type(data['link'], 'boardgamecategory'),
        mechanics:        BGGItemMaps::Helpers.extract_link_values_by_type(data['link'], 'boardgamemechanic'),
        families:         BGGItemMaps::Helpers.extract_link_values_by_type(data['link'], 'boardgamefamily'),
        expansions:       BGGItemMaps::Helpers.extract_link_values_by_type(data['link'], 'boardgameexpansion'),
        designers:        BGGItemMaps::Helpers.extract_link_values_by_type(data['link'], 'boardgamedesigner'),
        artists:          BGGItemMaps::Helpers.extract_link_values_by_type(data['link'], 'boardgameartist'),
        publishers:       BGGItemMaps::Helpers.extract_link_values_by_type(data['link'], 'boardgamepublisher')
      }
    end
  end


  # Datamap for BGG API's rpg items
  module RpgMap
    extend self
    # def parse(data:, bgg_id:)
    #   {
    #     bgg_id: bgg_id,
    #     name:   data
    #   }
    # end
  end
end
