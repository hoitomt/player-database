require 'rails_helper'

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
      expect{
        post :create, team_id: team.id, player: params
      }.to change{Player.count}.by(1)
    end

    it 'responds with a player' do
      post :create, team_id: team.id, player: params
      expect(response_body['name']).to eq params[:name]
      expect(response_body['number']).to eq params[:number].to_i
      expect(response_body['height_feet']).to eq params[:height_feet].to_i
      expect(response_body['height_inches']).to eq params[:height_inches].to_i
      expect(response_body['position']).to eq params[:position]
      expect(response_body['school']).to eq params[:school]
      expect(response_body['year']).to eq params[:year]
    end

    it 'adds a player to the team' do
      post :create, team_id: team.id, player: params
      player = team.reload.players.last

      expect(player.name).to eq params[:name]
      expect(player.number).to eq params[:number].to_i
      expect(player.height_feet).to eq params[:height_feet].to_i
      expect(player.height_inches).to eq params[:height_inches].to_i
      expect(player.position).to eq params[:position]
      expect(player.school).to eq params[:school]
      expect(player.year).to eq params[:year]

      expect(player.team_id).to eq team.id
    end
  end

  describe 'GET show' do
    let(:player) { create :player, team: team}

    it 'team and players route responds successfully' do
      get :show, team_id: team.id, id: player.id
      assert_response :success
    end

    it 'players route responds successfully' do
      get :show, id: player.id
      assert_response :success
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
      expect(response.body).to include 'Steph Curry'
      expect(response.body).to include 'Kevin Durant'
      expect(response.body).to_not include 'LeBron James'
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
      expect(response_body['name']).to eq 'Kevin Durant'
      expect(response_body['number']).to eq 35
    end
  end

  describe 'DELETE update' do
    let!(:player){ create :player, team_id: team.id, name: 'Kevin Duxant', number: 39}

    it 'responds successfully' do
      delete :destroy, team_id: team.id, id: player.id
      assert_response :success
    end

    it 'updates the player information' do
      expect{
        delete :destroy, team_id: team.id, id: player.id
      }.to change{Player.count}.by(-1)
    end
  end
end
