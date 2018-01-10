require 'game_geek/api'

RSpec.describe GameGeek::API do
  describe '.search_boardgames' do
    context 'with a valid search parameter' do
      context 'when it can connect to the API' do
        it 'returns an array of hashes' do
          # This also silently tests that HTTParty's #parsed_response method has not changed
          stub_successful_api_search_response

          search_result = GameGeek::API.search_boardgames('Gloomhaven')

          expect(search_result).to be_an_instance_of(Array)
          expect(search_result[0]).to be_an_instance_of(Hash)
        end
      end

      context 'when it cannot connect to the API' do
        it 'raises an error that the API is not available' do
          stub_api_unavailable_response

          expect { GameGeek::API.search_boardgames('Powergrid') }.to raise_error('Board Game Geek is not available')
        end
      end
    end

    context 'without a valid search parameter' do
      it 'raises an error that a parameter is required' do
        expect { GameGeek::API.search_boardgames('') }.to raise_error('Search query must not be empty')
      end
    end
  end

  describe '.get_boardgame' do
  end

  describe '.retrieve_bgg_item_ratings' do
  end

  def stub_successful_api_search_response
    stub_request(:get, 'https://www.boardgamegeek.com/xmlapi2/search?query=Gloomhaven&type=boardgame')
      .to_return(status:  200,
                 body:    File.open('spec/support/files/api_xml_search_response.xml'),
                 headers: { 'Content-Type' => 'text/xml; charset=UTF-8' })
  end

  def stub_api_unavailable_response
    stub_request(:get, 'https://www.boardgamegeek.com/xmlapi2/search?query=Powergrid&type=boardgame')
      .to_return(status: 404)
  end
end