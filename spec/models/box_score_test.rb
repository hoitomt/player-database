require "rails_helper"

class BoxScoreTest < ActiveSupport::TestCase
  def box_score
    @box_score ||= BoxScore.new
  end

  def test_valid
    assert box_score.valid?
  end
end
