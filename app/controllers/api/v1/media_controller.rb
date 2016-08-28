module Api
  module V1
    class MediaController < BaseController
      def upload_photo
        player_photo = PlayerPhoto.new
        player_photo.photo = params[:player_photo]

        player_photo.save!

        render json: player_photo
      end
    end
  end
end
