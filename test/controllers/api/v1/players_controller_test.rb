require 'test_helper'

describe Api::V1::PlayersController do
  let(:user) { create :user }
  let(:team) { create :team }
  let(:team2) { create :team }

  before do
    @request.headers['Authorization'] = "Token token=\"#{user.access_token}\""
  end

  describe 'GET index' do
    let(:params) {
      {
        name: 'Badgers'
      }
    }
  end

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
