class PlayerPhoto < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  belongs_to :player
end
