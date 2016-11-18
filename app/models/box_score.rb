class BoxScore < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  def date
  	self.game.present? ? self.game.date : nil
  end

  def opponent
  	self.game.present? ? self.game.opponent : nil
  end
end
