require 'test_helper'

describe Api::V1::PlayersController do
  let(:user) { create :user }
  let(:team) { create :team }

  before do
    @request.headers['Authorization'] = "Token token=\"#{user.access_token}\""
  end

  let(:response_body){JSON.parse(response.body)}

  describe 'POST create' do
    let(:params) {
      {
        name: 'Kevin Durant',
        number: '35',
        height_feet: '6',
        height_inches: '11',
        position: 'PG',
        school: 'Texas',
        year: '2005'
      }
    }

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
      response_body['height_feet'].must_equal params[:height_feet].to_i
      response_body['height_inches'].must_equal params[:height_inches].to_i
      response_body['position'].must_equal params[:position]
      response_body['school'].must_equal params[:school]
      response_body['year'].must_equal params[:year]
    end

    it 'adds a player to the team' do
      post :create, team_id: team.id, player: params
      player = team.reload.players.last

      player.name.must_equal params[:name]
      player.number.must_equal params[:number].to_i
      player.height_feet.must_equal params[:height_feet].to_i
      player.height_inches.must_equal params[:height_inches].to_i
      player.position.must_equal params[:position]
      player.school.must_equal params[:school]
      player.year.must_equal params[:year]

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

  describe 'PUT update' do
    let(:player){ create :player, team_id: team.id, name: 'Kevin Duxant', number: 39}

    it 'responds successfully' do
      put :update, team_id: team.id, id: player.id, player: {name: 'Kevin Durant', number: 35}
      assert_response :success
    end

    it 'updates the player information' do
      put :update, team_id: team.id, id: player.id, player: {name: 'Kevin Durant', number: 35}
      response_body['name'].must_equal 'Kevin Durant'
      response_body['number'].must_equal 35
    end
  end

  describe 'DELETE update' do
    let!(:player){ create :player, team_id: team.id, name: 'Kevin Duxant', number: 39}

    it 'responds successfully' do
      delete :destroy, team_id: team.id, id: player.id
      assert_response :success
    end

    it 'updates the player information' do
      -> {
        delete :destroy, team_id: team.id, id: player.id
      }.must_change 'Player.count', -1
    end
  end
end
