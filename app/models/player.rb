class Player < ActiveRecord::Base
  belongs_to :team

  has_many :box_scores
  has_many :games, through: :box_scores

  validates_uniqueness_of :number, scope: [:name, :team_id]
end
