module Api
  module V1
    class PlayersController < BaseController
      before_filter :find_team

      def index
        @players = @team.players
        render json: @players.to_json(include: :profile_photo)
      end

      def show
        @player = Player.find_by_id(params[:id])
        render json: @player.to_json(include: :profile_photo)
      end

      def create
        @player = @team.players.create(player_params)
        if params[:player][:photo_id]
          @player.set_profile_photo(params[:player][:photo_id])
        end
        render json: @player.to_json
      end

      def update
        @player = @team.players.find_by_id(params[:id])
        @player.update_attributes(player_params)
        @player.set_profile_photo(params[:player][:photo_id])
        render json: @player.to_json
      end

      def destroy
        @player = @team.players.find_by_id(params[:id])
        @player.destroy
        render json: {}
      end

      private

      def player_params
        params.require(:player).permit(:name, :number,
          :height_feet, :height_inches, :position, :school, :year)
      end

      def find_team
        @team = Team.find_by_id(params[:team_id])
      end
    end
  end
end
