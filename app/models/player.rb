class Player < ActiveRecord::Base
  belongs_to :team
  has_many :player_photos, dependent: :destroy

  has_many :box_scores
  has_many :games, through: :box_scores

  validates_uniqueness_of :number, scope: [:name, :team_id]

  def set_profile_photo(photo_id)
    # Unset all other player photos
    self.player_photos.each do |pp|
      pp.update_attributes(profile_photo: false)
    end

    photo = PlayerPhoto.find(photo_id)
    photo.profile_photo = true
    photo.player_id = self.id
    photo.save!
  end

  def profile_photo
    self.player_photos.where(profile_photo: true).first
  end
end
