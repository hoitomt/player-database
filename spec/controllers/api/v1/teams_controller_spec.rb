require 'rails_helper'

describe Api::V1::TeamsController do
  let(:user) { create :user}

  before do
    @request.headers['Authorization'] = "Token token=\"#{user.access_token}\""
  end

  describe 'POST create' do
    let(:params) {
      {
        name: 'Badgers'
      }
    }

    it 'responds successfully' do
      post :create, team: params
      assert_response :success
    end

    it 'adds a team' do
      expect{
        post :create, team: params
      }.to change{Team.count}.by(1)
    end

    it 'adds a team to the user' do
      post :create, team: params
      team = user.reload.teams.last
      expect(team.name).to eq 'Badgers'
    end

    describe 'players' do
      let(:team){ Team.last }
      let(:params) {
        {
          name: 'Badgers',
          players: [
            {
              name: 'Stephen Curry',
              number: 30
            },
            {
              name: 'Lebron James',
              number: 23
            }
          ]
        }
      }

      it 'adds players to the team' do
        expect{
          post :create, team: params
        }.to change{Player.count}.by(2)
      end

      it 'add the correct players to the team' do
        post :create, team: params
        expect(team.reload.players.find_by_name('Stephen Curry').number).to eq 30
        expect(team.reload.players.find_by_name('Lebron James').number).to eq 23
      end

      it 'returns the players in the response' do
        post :create, team: params
        j_response = JSON.parse(response.body)
        expect(j_response['players'].length).to eq 2
      end
    end
  end

  describe 'PUT update' do
    let(:team){create :team, user: user}

    let(:params) {
      {
        name: 'Updated Name'
      }
    }

    it 'responds successfully' do
      put :update, id: team.id, team: params
      assert_response :success
    end

    it 'updates the value' do
      put :update, id: team.id, team: params
      expect(team.reload.name).to eq 'Updated Name'
    end

    it 'with invalid team id' do
      put :update, id: 'bad', team: params
      assert_response :unprocessable_entity
    end

    describe 'players' do
      let(:steph){create :player, name: 'Stephen Curry', number: 30, team: team }
      let(:lebron){create :player, name: 'Lebron James', number: 23, team: team }
      let!(:params) {
        {
          name: 'Badgers',
          players: [
            {
              id: steph.id,
              name: steph.name,
              number: 44
            },
            {
              id: lebron.id,
              name: lebron.name,
              number: lebron.number
            },
            {
              id: nil,
              name: 'Klay Thompson',
              number: 11
            }
          ]
        }
      }

      it 'updates the players' do
        put :update, id: team.id, team: params
        expect(steph.reload.number).to eq 44
      end

      it 'adds new players' do
        expect{
          put :update, id: team.id, team: params
        }.to change{Player.count}.by(1)
      end

      it 'adds new players to the team' do
        put :update, id: team.id, team: params
        expect(team.reload.players.count).to eq 3
        expect(Player.find_by_name('Klay Thompson').team).to eq team
      end
    end
  end

end
