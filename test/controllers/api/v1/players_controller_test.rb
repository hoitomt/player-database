require 'test_helper'

describe Api::V1::PlayersController do
  let(:user) { create :user }
  let(:team) { create :team }

  before do
    @request.headers['Authorization'] = "Token token=\"#{user.access_token}\""
  end

  describe 'POST create' do
    let(:params) {
      {
        name: 'Kevin Durant',
        number: '35'
      }
    }
    let(:response_body){JSON.parse(response.body)}

    it 'responds successfully' do
      post :create, team_id: team.id, player: params
      assert_response :success
    end

    it 'adds a player' do
      -> {
        post :create, team_id: team.id, player: params
      }.must_change 'Player.count', +1
    end

    it 'responds with a player' do
      post :create, team_id: team.id, player: params
      response_body['name'].must_equal params[:name]
      response_body['number'].must_equal params[:number].to_i
    end

    it 'adds a player to the team' do
      post :create, team_id: team.id, player: params
      player = team.reload.players.last
      player.name.must_equal 'Kevin Durant'
      player.number.must_equal 35
      player.team_id.must_equal team.id
    end
  end

  describe 'GET index' do
    let(:team2) { create :team }

    it 'responds successfully' do
      get :index, team_id: team.id
      assert_response :success
    end

    it 'responds with a list of players' do
      create :player, team_id: team.id, name: 'Steph Curry', number: 30
      create :player, team_id: team.id, name: 'Kevin Durant', number: 35
      create :player, team_id: team2.id, name: 'Lebron James', number: 23

      get :index, team_id: team.id
      response.body.must_include 'Steph Curry'
      response.body.must_include 'Kevin Durant'
      response.body.wont_include 'LeBron James'
    end
  end
end
