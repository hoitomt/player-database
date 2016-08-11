class Game < ActiveRecord::Base
  belongs_to :team

  has_many :box_scores
  has_many :players, through: :box_scores

  def self.create_with_box_scores(game_params, box_score_params)
    game = self.create(game_params)
    game.add_box_scores(box_score_params || [])
    game
  end

  def add_box_scores(box_score_params)
    box_score_params.each do |box_score_param|
      self.box_scores << BoxScore.create!(box_score_param)
    end
  end

  def update_with_box_score(game_params, box_score_params)
    update_attributes(game_params)
    (box_score_params || []).each do |box_score_param|
      box_score = self.box_scores.find_by_player_id(box_score_param[:player_id])
      if box_score
        box_score.update_attributes(box_score_param)
      else
        self.box_scores << BoxScore.create!(box_score_param)
      end
    end
  end

end
