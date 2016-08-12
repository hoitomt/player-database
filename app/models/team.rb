class Team < ActiveRecord::Base
  belongs_to :user

  has_many :players
  has_many :games

  def self.create_with_players(team_params, players_params)
    team = self.create(team_params)
    team.add_players(players_params || [])
    team
  end

  def add_players(players_params=[])
    players_params.each do |player_params|
      self.players << Player.create!(player_params)
    end
  end

  def update_with_players(team_params, players_params)
    update_attributes(team_params)
    add_or_update_players(players_params || [])
  end

  def add_or_update_players(players_params=[])
    players_params.each do |player_params|
      player_params[:team_id] = self.id
      player = Player.find_by_id(player_params.delete(:id).to_i)
      if player
        player.update_attributes(player_params)
      else
        self.players << Player.create!(player_params)
      end
    end
  end
end
