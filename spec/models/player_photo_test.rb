require "rails_helper"

class PlayerPhotoTest < ActiveSupport::TestCase
  def player_photo
    @player_photo ||= PlayerPhoto.new
  end

  def test_valid
    assert player_photo.valid?
  end
end
