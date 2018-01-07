class Game
  # Uses BGG API 2
  # /xmlapi2/thing?id=:bgg_id

  attr_reader :bgg_id
  attr_reader :name, :alternate_names
  attr_reader :description
  attr_reader :year_published
  attr_reader :min_players
  attr_reader :max_players
  attr_reader :suggested_num_players
  attr_reader :playing_time
  attr_reader :min_playing_time
  attr_reader :max_playing_time
  attr_reader :min_age
  attr_reader :suggested_age
  attr_reader :categories # [{ bgg_id: INT, bgg_category: STRING }]
  attr_reader :mechanics  # [{ bgg_id: INT, bgg_mechanic: STRING }]
  attr_reader :families   # [{ bgg_id: INT, bgg_family: STRING }]
  attr_reader :expansions # [{ bgg_id: INT, bgg_name: STRING  }]
  attr_reader :designers  # [{ bgg_id: INT, bgg_designer: STRING }]
  attr_reader :artists    # [{ bgg_id: INT, bgg_artist: STRING }]
  attr_reader :publisher  # [{ bgg_id: INT, bgg_publisher: STRING }]
end