require 'spec_helper'

RSpec.describe GameGeek do
  it 'has a version number' do
    expect(GameGeek::VERSION).not_to be nil
  end

  it 'has an API connector' do
    expect(GameGeek::API).not_to be nil
  end

  it 'can instantiate boardgames' do
    expect(GameGeek::Boardgame).not_to be nil
    expect(GameGeek::Boardgame).to respond_to(:new)
  end

  it 'has a map of the BGG API responses' do
    expect(GameGeek::BggMap).not_to be nil
  end

  describe '::BggMap' do
    it 'maps search responses' do
      expect(GameGeek::BggMap::Search).not_to be nil
    end

    it 'maps BGG thing responses' do
      expect(GameGeek::BggMap::Thing).not_to be nil
    end

    describe '::Thing' do
      it 'provides helpers' do
        expect(GameGeek::BggMap::Thing::Helpers).not_to be nil
      end

      it 'maps boardgame thing responses' do
        expect(GameGeek::BggMap::Thing::BoardgameMap).not_to be nil
      end
    end
  end
end
