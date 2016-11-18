require "rails_helper"

describe BoxScoresController do
	let(:user){ create :user}
	let(:player){ create :player, team: team }
	let(:team){ create :team, user: user }
	let(:params){
		{
			"box_score_date"=>"11/16/2016",
			"box_score_opponent"=>"Test Opponent",
			"box_score"=> {
				"total_points"=>"15",
				"assists"=>"2",
				"rebounds"=>"4",
				"two_point_make"=>"3",
				"two_point_attempt"=>"5",
				"three_point_make"=>"2",
				"three_point_attempt"=>"7",
				"one_point_make"=>"3",
				"one_point_attempt"=>"4"
			},
			"team_id"=> team.id,
			"player_id"=> player.id
		}
	}

	before do
		sign_in user
	end

	it 'passes' do
		expect(true).to eq(true)
	end

	describe '#create' do
		describe 'box_score' do
			it 'creates a new box score' do
				expect{ post :create, params }.to change{BoxScore.count}.by(1)
			end

			it 'sets the correct parameters' do
				post :create, params
				box_score = BoxScore.last
				game = Game.last
				expect(box_score.player_id).to eq(player.id)
				expect(box_score.game.id).to eq(game.id)
				expect(box_score.total_points).to eq(params['box_score']['total_points'].to_i)
				expect(box_score.assists).to eq(params['box_score']['assists'].to_i)
				expect(box_score.rebounds).to eq(params['box_score']['rebounds'].to_i)
				expect(box_score.two_point_make).to eq(params['box_score']['two_point_make'].to_i)
				expect(box_score.two_point_attempt).to eq(params['box_score']['two_point_attempt'].to_i)
				expect(box_score.three_point_make).to eq(params['box_score']['three_point_make'].to_i)
				expect(box_score.three_point_attempt).to eq(params['box_score']['three_point_attempt'].to_i)
				expect(box_score.one_point_make).to eq(params['box_score']['one_point_make'].to_i)
				expect(box_score.one_point_attempt).to eq(params['box_score']['one_point_attempt'].to_i)
			end
		end

		describe '#game' do
			it 'creates a new game' do
				expect{ post :create, params }.to change{Game.count}.by(1)
			end

			it 'sets the correct parameters' do
				post :create, params
				game = Game.last
				expect(game.date).to eq(Date.strptime(params['box_score_date'], '%m/%d/%Y'))
				expect(game.opponent).to eq(params['box_score_opponent'])
			end
		end

	end
end
