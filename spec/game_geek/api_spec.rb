require 'game_geek/api'

RSpec.describe GameGeek::API do
  context 'when it can connect to the BGG API' do
    describe '.search_boardgames' do
      context 'with a valid search parameter' do
        context 'the parameter has results' do
          it 'returns an array of hashes' do
            # This also silently tests that HTTParty's #parsed_response method has not changed
            stub_successful_api_search

            search_result = GameGeek::API.search_boardgames('Gloomhaven')

            expect(search_result).to be_an_instance_of(Array)
            expect(search_result[0]).to be_an_instance_of(Hash)
          end
        end

        context 'the parameter returns no results' do
          it 'returns an empty array' do
            stub_empty_api_search

            search_result = GameGeek::API.search_boardgames('NotAGame')

            expect(search_result).to be_an_instance_of(Array)
            expect(search_result.size).to eq(0)
          end
        end
      end

      context 'without a valid search parameter' do
        it 'raises an error that a search parameter is required' do
          expect { GameGeek::API.search_boardgames('') }.to raise_error('Search query must not be empty')
        end
      end
    end

    describe '.get_boardgame' do
      context 'when provided with a valid ID parameter' do
        context 'when the ID retrieves an object from the API' do
          it 'returns a hash of boardgame data' do
            stub_successful_api_retrieval
            response = GameGeek::API.get_boardgame(bgg_id: 174430)

            expect(response).to be_an_instance_of(Hash)
            expect(response[:bgg_id]).to eq(174430)
          end

          it 'includes a useful status message that the retrieval was a success' do
            stub_successful_api_retrieval
            response = GameGeek::API.get_boardgame(bgg_id: 174430)

            expect(response[:status]).to eq('found')
          end

          context 'when the original response is requested' do
            it 'includes the XML response in the hash' do
              stub_successful_api_retrieval
              response = response = GameGeek::API.get_boardgame(bgg_id: 174430, include_original_response: true)

              expect(response[:response_body]).to eq(File.read('spec/support/files/api_xml_retrieval_response.xml'))
            end
          end
        end

        context 'when the ID does not retrieve an object from the API' do
          it 'returns a response that no item was found' do
            stub_empty_api_retrieval
            response = GameGeek::API.get_boardgame(bgg_id: 10000000000)

            expect(response[:status]).to eq('not found')
          end
        end
      end
    end

    describe '.retrieve_bgg_item_ratings' do
      context 'when given a valid game id' do
        it 'gets a count of available ratings'
        it 'returns an overall score'
        it 'provides a link to read the rating comments on BGG'
        context 'when there are 100 or fewer ratings' do
          it 'gets all ratings'
        end
        context 'when there are more than 100 ratings' do
          it 'makes multiple requests to get all ratings'
        end
      end
    end
  end

  context 'when it cannot connect to the BGG API' do
    it 'raises an error that the API is not available' do
      stub_api_unavailable

      expect { GameGeek::API.search_boardgames('Powergrid') }.to raise_error('Board Game Geek is not available')
    end
  end

  def stub_successful_api_search
    stub_request(:get, 'https://www.boardgamegeek.com/xmlapi2/search?query=Gloomhaven&type=boardgame')
      .to_return(status:  200,
                 body:    File.read('spec/support/files/api_xml_search_response.xml'),
                 headers: { 'Content-Type' => 'text/xml; charset=UTF-8' })
  end

  def stub_empty_api_search
    stub_request(:get, 'https://www.boardgamegeek.com/xmlapi2/search?query=NotAGame&type=boardgame')
      .to_return(status:  200,
                 body:    File.read('spec/support/files/api_xml_failed_search.xml'),
                 headers: { 'Content-Type' => 'text/xml; charset=UTF-8' })
  end

  def stub_successful_api_retrieval
    stub_request(:get, 'https://www.boardgamegeek.com/xmlapi2/thing?id=174430&type=boardgame')
      .to_return(status:  200,
                 body:    File.read('spec/support/files/api_xml_retrieval_response.xml'),
                 headers: { 'Content-Type' => 'text/xml; charset=UTF-8' })
  end

  def stub_empty_api_retrieval
    stub_request(:get, 'https://www.boardgamegeek.com/xmlapi2/thing?id=10000000000&type=boardgame')
      .to_return(status:  200,
                 body:    File.read('spec/support/files/api_xml_failed_retrieval.xml'),
                 headers: { 'Content-Type' => 'text/xml; charset=UTF-8' })
  end

  def stub_api_unavailable
    stub_request(:get, 'https://www.boardgamegeek.com/xmlapi2/search?query=Powergrid&type=boardgame')
      .to_return(status: 404)
  end
end