require 'test_helper'

describe "Player" do
  let(:team){ create :team }
  let(:player){ create :player, name: 'Stephen Curry', number: 30, team: team }

  describe 'uniqueness' do
    it 'will not create another player on the same team with the same name and number' do
      Player.new({name: player.name, number: player.number, team: team}).valid?.must_equal false
    end
  end
end
