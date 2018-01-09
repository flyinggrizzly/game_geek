# GameGeek

GameGeek is a tool for interacting with the (Boardgame | RPG | Videogame)Geek website XML API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'game_geek'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install game_geek

## Usage

The BGG API has a concept of 'things' (or very occasionally 'items'). This API connector will help you search and retrieve these things.

Instead of relying on you to know how BGG/RPGG/VGG classify and name their things, `GameGeek` is intended to give you clear methods for search and retrieval by game type (boardgame, rpg, videogame)

### Searching by 'thing' type

Use the API connector to search the API's things by type. It will return a hash array with each result's name, and ID, and type (which will correspond directly to the type you searched by):

```ruby
GameGeekApi.search_boardgames('Gloomhaven')
=> [{:id=>"214032", :title=>"Founders of Gloomhaven", :type=>"boardgame"},
    {:id=>"174430", :title=>"Gloomhaven", :type=>"boardgame"},
    {:id=>"226868", :title=>"Gloomhaven: Solo Scenarios", :type=>"boardgame"},
    {:id=>"231934", :title=>"Gloomhaven: The End of the World (Promo Scenario)", :type=>"boardgame"}]
```

The other available search methods are `GameGeekApi.search_rpgs` and `GameGeekApi.search_videogames`

### Retrieving a thing

To retrieve the data for an API thing, call the relevant `#get_` method, and supply the BGG ID parameter (presumably retrieved from search, but this is also in every BGG thing's URL on the sites). You can optionally retrieve the original XML response from the API by passing `true` to the method.

```ruby
GameGeekApi.get_boardgame(bgg_id: 174430)
=> { giant: "hash" }

GameGeekApi.get_rpg(bgg_id: 162994, include_original_response: true)
=> { giant: "hash", response_body: "so much XML" }
```

If you want to see exactly what data is returned in the hash, best check out the [data mapping modules](/lib/game_geek/bgg_item_maps.rb). At the moment, the only notable data not being returned that's available are the aggregated scores and ratings. This will come.

## Known limitations

The biggest found so far isn't a problem of this gem (though I'm sure I'll find those), but rather that it's not currently possible to search games in the API by their designer. You can find the designer, but there is no way to query their works in the API at the moment. This is [planned](https://boardgamegeek.com/wiki/page/XML_API_Enhancements#toc1), but there's no delivery date at the moment.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/flyinggrizzly/game_geek.

## Credits

Lotta cred to [BoardGameGem](http://www.github.com/acceptableice/boardgamegem) and the [boardgamegeek](https://github.com/lcosmin/boardgamegeek/) Python packages!

## LICENSE

AGPL 3.0