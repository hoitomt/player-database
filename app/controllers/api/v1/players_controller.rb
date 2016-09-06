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
        add_or_update_profile_photo
        render json: @player.to_json
      end

      def update
        @player = @team.players.find_by_id(params[:id])
        @player.update_attributes(player_params)
        add_or_update_profile_photo
        render json: @player.to_json
      end

      def destroy
        @player = @team.players.find_by_id(params[:id])
        @player.destroy
        render json: {}
      end

      private

      def add_or_update_profile_photo
        if params[:player][:profile_photo]
          @player.set_profile_photo(params[:player][:profile_photo][:id])
        end
      end

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
