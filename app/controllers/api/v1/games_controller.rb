module Api
  module V1
    class GamesController < BaseController
      def index
        team = Team.find_by_id(params[:team_id])
        if team
          @games = team.games
          render json: @games.to_json(include: :box_scores)
        else
          head :unprocessable_entity
        end
      end

      def create
        @game = Game.create_with_box_scores(team_game_params, game_box_score_params)
        if @game.valid?
          render json: @game.to_json(include: :box_scores)
        else
          render json: {errors: @game.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def update
        @game = Game.find_by_id(params[:id])
        if @game
          @game.update_with_box_score(team_game_params, game_box_score_params)
          render json: @game.to_json(include: :box_scores)
        else
          head :unprocessable_entity
        end
      end

      private

      def team
        @team = Team.find(params[:team_id])
      end

      def team_game_params
        game_params.merge({team_id: team.id})
      end

      def game_params
        params.require(:game).permit(:opponent, :date, :team_id, :device_id)
      end

      def game_box_score_params
        allowed_params = [:player_id, :one_point_attempt, :one_point_make,
          :two_point_attempt, :two_point_make, :three_point_attempt,
          :three_point_make, :turnovers, :assists, :fouls, :rebounds, :device_id]
        params.require(:game).permit(box_scores: allowed_params)[:box_scores]
      end
    end
  end
end
