require 'game_geek/api'

RSpec.describe GameGeek::API do
  describe '.search_boardgames' do
    context 'with a valid search parameter' do
      context 'when it can connect to the API' do
        it 'returns an array of hashes'
      end

      context 'when it cannot connect to the API' do
        it 'raises an error that the API is not available'
      end
    end

    context 'without a valid search parameter' do
      it 'raises an error that a parameter is required'
    end
  end

  describe '.get_boardgame' do
  end

  describe '.retrieve_bgg_item_ratings' do
  end
end