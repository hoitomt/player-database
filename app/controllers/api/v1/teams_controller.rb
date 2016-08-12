module Api
  module V1
    class TeamsController < BaseController
      def index
        @teams = current_user.teams
        render json: @teams.to_json(include: :players)
      end

      def show
        @team = Team.find_by_id(params[:id])
        render json: @team.to_json(include: :players)
      end

      def create
        @team = Team.create_with_players(team_user_params, team_player_params)
        if @team.valid?
          render json: @team.to_json(include: :players)
        else
          render json: {errors: @team.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def update
        @team = Team.find_by_id(params[:id])
        if @team
          @team.update_with_players(team_params, team_player_params)
          render json: @team.to_json(include: :players)
        else
          head :unprocessable_entity
        end
      end

      private

      def team_user_params
        team_params.merge({user: current_user})
      end

      def team_params
        params.require(:team).permit(:name, :device_id)
      end

      def team_player_params
        params.require(:team).permit(players: [:id, :name, :number, :device_id])[:players]
      end
    end
  end
end
