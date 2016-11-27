module Api
	module V1
		class BoxScoresController < BaseController
			def index
        render json: box_scores.to_json
			end

			private

			def box_scores
				scope = BoxScore.joins(:player, :game)
				scope = scope.select("players.number, players.name, TO_CHAR(games.date, 'MM/DD/YYYY'), games.opponent, box_scores.*")
				scope = scope.order("players.name")

				# Date format: &start_date='2016-11-01'
				scope = scope.where("games.date >= ?", params[:start_date]) if params[:start_date].present?

				# Date format: &end_date='2016-11-01'
				scope = scope.where("games.date <= ?", params[:end_date]) if params[:end_date].present?
				scope
			end
		end
	end
end
