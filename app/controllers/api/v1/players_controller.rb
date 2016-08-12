module Api
  module V1
    class PlayersController < BaseController
      before_filter :find_team

      def index
        @players = @team.players
        render json: @players.to_json
      end

      def show
        @player = @team.players.find_by_id(params[:id])
        render json: @player.to_json
      end

      private

      def find_team
        @team = Team.find_by_id(params[:team_id])
      end
    end
  end
end
