require 'test_helper'

describe Api::V1::GamesController do
  let(:user) { create :user}
  let(:team) { create :team}

  before do
    @request.headers['Authorization'] = "Token token=\"#{user.access_token}\""
  end

  describe 'POST create' do
    let(:params) {
      {
        opponent: 'Buckeyes',
        date: "2015-09-30"
      }
    }

    it 'responds successfully' do
      post :create, team_id: team.id, game: params
      assert_response :success
    end

    it 'adds a game' do
      -> {
        post :create, team_id: team.id, game: params
      }.must_change 'Game.count', +1
    end

    it 'adds a game to the team' do
      post :create, team_id: team.id, game: params
      game = team.reload.games.last
      game.opponent.must_equal 'Buckeyes'
      game.date.must_equal Date.new(2015, 9, 30)
      game.team_id.must_equal team.id
    end

    describe 'POST create with box_scores' do
      let(:player1){ create :player, number: 30, team: team }
      let(:player2){ create :player, number: 23, team: team }

      let(:params) {
        {
          opponent: 'Buckeyes',
          date: '2015-09-30',
          box_scores: [
            {
              id: nil,
              player_id: player1.id,
              one_point_attempt: 3,
              one_point_make: 2,
              two_point_attempt: 4,
              two_point_make: 2,
              three_point_attempt: 6,
              three_point_make: 4,
              turnovers: 1,
              assists: 3,
              fouls: 2,
              rebounds: 5
            },
            {
              id: nil,
              player_id: player2.id,
              one_point_attempt: 6,
              one_point_make: 3,
              two_point_attempt: 7,
              two_point_make: 2,
              three_point_attempt: 4,
              three_point_make: 2,
              turnovers: 2,
              assists: 4,
              fouls: 3,
              rebounds: 7
            }
          ]
        }
      }

      it 'adds a game' do
        -> {
          post :create, team_id: team.id, game: params
        }.must_change 'Game.count', +1
      end

      it 'adds box_scores to the game' do
        -> {
          post :create, team_id: team.id, game: params
        }.must_change 'BoxScore.count', +2
      end

      it 'adds a game to the team' do
        post :create, team_id: team.id, game: params
        game = team.reload.games.last
        game.opponent.must_equal 'Buckeyes'
        game.date.must_equal Date.new(2015, 9, 30)
        game.team_id.must_equal team.id
      end
    end

  end

  describe 'PUT update' do
    let(:game){ create :game, team: team }
    let(:player1){ create :player, number: 30 }
    let(:player2){ create :player, number: 23 }

    let(:params) {
      {
        opponent: 'Updated Name',
        date: game.date,
        box_scores: [
          {
            id: nil,
            player_id: player1.id,
            one_point_attempt: 3,
            one_point_make: 2,
            two_point_attempt: 4,
            two_point_make: 2,
            three_point_attempt: 6,
            three_point_make: 4,
            turnovers: 1,
            assists: 3,
            fouls: 2,
            rebounds: 5
          },
          {
            id: nil,
            player_id: player2.id,
            one_point_attempt: 6,
            one_point_make: 3,
            two_point_attempt: 7,
            two_point_make: 2,
            three_point_attempt: 4,
            three_point_make: 2,
            turnovers: 2,
            assists: 4,
            fouls: 3,
            rebounds: 7
          }
        ]
      }
    }

    it 'responds successfully' do
      put :update, team_id: team.id, id: game.id, game: params
      assert_response :success
    end

    it 'updates the value' do
      put :update, team_id: team.id, id: game.id, game: params
      game.reload.opponent.must_equal 'Updated Name'
    end

    it 'with invalid game id' do
      put :update, team_id: team.id, id: 'bad', game: params
      assert_response :unprocessable_entity
    end

    describe 'box score' do
      it 'create new box score records' do
        -> {
          put :update, team_id: team.id, id: game.id, game: params
        }.must_change 'BoxScore.count', +2
      end

      it 'correctly populates box score' do
        put :update, team_id: team.id, id: game.id, game: params
        box_scores = player1.reload.box_scores
        box_scores.length.must_equal 1
        box_score = box_scores.first

        box_score.one_point_attempt.must_equal 3
        box_score.one_point_make.must_equal 2
        box_score.two_point_attempt.must_equal 4
        box_score.two_point_make.must_equal 2
        box_score.three_point_attempt.must_equal 6
        box_score.three_point_make.must_equal 4
        box_score.turnovers.must_equal 1
        box_score.assists.must_equal 3
        box_score.fouls.must_equal 2
        box_score.rebounds.must_equal 5
      end
    end

    describe 'update existing box score' do
      let!(:player1_box_score){ create :box_score, player: player1, game: game }
      let!(:player2_box_score){ create :box_score, player: player2, game: game }

      it 'updates an existing box_score' do
        -> {
          put :update, team_id: team.id, id: game.id, game: params
        }.must_change 'BoxScore.count', +0
      end

      it 'updates an existing box_score' do
        put :update, team_id: team.id, id: game.id, game: params
        player2_box_score.reload
        player2_box_score.one_point_attempt.must_equal 6
        player2_box_score.one_point_make.must_equal 3
        player2_box_score.two_point_attempt.must_equal 7
        player2_box_score.two_point_make.must_equal 2
        player2_box_score.three_point_attempt.must_equal 4
        player2_box_score.three_point_make.must_equal 2
        player2_box_score.turnovers.must_equal 2
        player2_box_score.assists.must_equal 4
        player2_box_score.fouls.must_equal 3
        player2_box_score.rebounds.must_equal 7
      end

    end
  end
end
