# frozen_string_literal: true

require './spec/spec_helper'

require 'engine/game/g_1889'
require 'engine/part/city'
require 'json'

module Engine
  describe Game::G1889 do
    let(:players) { %w[a b] }
    subject { Game::G1889.new(players) }

    context 'on init' do
      it 'starts with correct cash' do
        expect(subject.bank.cash).to eq(6160)
        expect(subject.players.map(&:cash)).to eq([420, 420])
      end

      it 'starts with an auction' do
        expect(subject.round).to be_a(Round::Auction)
      end

      it 'starts with player a' do
        expect(subject.round.entities).to eq(subject.players)
        expect(subject.round.current_entity).to eq(subject.players.first)
        expect(subject.current_entity).to eq(subject.players.first)
      end
    end

    context 'on init with actions' do
      let(:initial_actions) do
        [
          { 'type' => 'pass', 'entity' => 'a', 'entity_type' => 'player' },
          { 'type' => 'message', 'entity' => 'a', 'entity_type' => 'player', 'message' => 'testing' },
          { 'type' => 'pass', 'entity' => 'b', 'entity_type' => 'player' },
          { 'type' => 'undo', 'entity' => 'a', 'entity_type' => 'player', 'steps' => 1 },
        ]
      end
      subject { Game::G1889.new(players, actions: initial_actions) }
      it 'should process constructor actions' do
        expect(subject.actions.size).to be 4
        expect(subject.current_entity.name).to be players[1]
      end
    end

    context 'full game' do
      RESULTS = {
        68 => {
          'Kruizey' => 326,
          'RobbieT' => 180,
          'bugscheese' => 723,
          'takeoutweight' => 702,
        },
        164 => {
          'Anvil' => 7258,
          'Gamergeek65' => 6885,
        },
        233 => {
          'dionhut' => 7844,
          'hhlodesign' => 7655,
          'raj' => 8050,
        },
        247 => {
          'fdinh' => 1094,
          'gugvib' => 1148,
          'marco4884' => 1089,
          'vecchioleone' => 305,
        },
        314 => {
          'Rebus' => 1134,
          'johnhawkhaines' => 260,
          'scottredracecar' => 1473,
        },
        319 => {
          'Avemo3' => 6586,
          'Hushed' => 3511,
          'Skanadron' => 5351,
        },
      }.freeze

      RESULTS.each do |game_id, result|
        it "#{game_id} matches result exactly" do
          data = JSON.parse(File.read("spec/fixtures/1889/#{game_id}.json"))
          players = data['players'].map { |p| p['name'] }
          expect(subject.class.new(players, actions: data['actions']).result).to eq(result)
        end
      end
    end
  end
end
