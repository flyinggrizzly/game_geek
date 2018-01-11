# Isolate knowledge of BGG's API response structures,
# and more specifically HTTParty's parsing of them,
# into a module for maintenance and decoupling.
module GameGeek
  module BggMap
    module Search
      extend self

      def parse(data:, search_type:)
        results = []
        data['items']['item'].each do |item|
          results << { id: item['id'], title: item['name']['value'], type: search_type }
        end
        results
      end
    end

    module Thing
      # Share parsing methods for BGG Items' data structures.
      module Helpers
        extend self

        BGG_LINK_TYPES = %w[boardgamecategory
                            boardgamemechanic
                            boardgamefamily
                            boardgameexpansion
                            boardgamedesigner
                            boardgameartist
                            boardgamepublisher].freeze

        # Given the items['item'] attribute produced by HTTParty from a BGG API
        # XML response as data, and a type of name to extract, returns either a
        # string for the primary name, or an array of strings of alternate names.
        def extract_names_by_type(data, type)
          names = data['items']['item']['name'].select { |name| name['type'] == type }
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
        def extract_link_values_by_type(data, link_type)
          raise 'Link type is invalid' unless BGG_LINK_TYPES.include? link_type

          links = data['items']['item']['link']
          links_of_type = links.select { |link| link['type'].eql?(link_type) }
          links_of_type.map { |link| link['value'] }
        end
      end


      # Datamap for BGG API's boarditem items.
      # Does not yet return BGG's suggested number of players, or 
      # suggested age.
      module BoardgameMap
        extend self

        def parse(data)
          game = data['items']['item']
          {
            bgg_id:           game['id'].to_i,
            name:             GameGeek::BggMap::Thing::Helpers.extract_names_by_type(data, 'primary'),
            alternate_names:  GameGeek::BggMap::Thing::Helpers.extract_names_by_type(data, 'alternate'),
            description:      game['description'],
            year_published:   game['yearpublished']['value'],
            min_players:      game['minplayers']['value'],
            max_players:      game['maxplayers']['value'],
            # suggested_num_players: TODO: work out how this is calculated
            playing_time:     game['playingtime']['value'],
            min_playing_time: game['minplaytime']['value'],
            max_playing_time: game['maxplaytime']['value'],
            min_age:          game['minage']['value'],
            # suggested_age: TODO: work out how this is calculated
            categories:       GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(data, 'boardgamecategory'),
            mechanics:        GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(data, 'boardgamemechanic'),
            families:         GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(data, 'boardgamefamily'),
            expansions:       GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(data, 'boardgameexpansion'),
            designers:        GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(data, 'boardgamedesigner'),
            artists:          GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(data, 'boardgameartist'),
            publishers:       GameGeek::BggMap::Thing::Helpers.extract_link_values_by_type(data, 'boardgamepublisher')
          }
        end
      end


      # Datamap for BGG API's rpg items
      module RpgMap
        extend self
        def parse(data:, bgg_id:)
        end
      end


      # Datamap for BGG API's videogame items
      module VideogameMap
        extend self
        def parse(data:, bgg_id:)
        end
      end
    end

    module BggPeople
    end
  end
end