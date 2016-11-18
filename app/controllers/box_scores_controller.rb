class BoxScoresController < ApplicationController
	before_action :get_player
	before_action :validate_game, only: [:create, :update]
	before_action :find_or_create_game, only: [:create]

	def index
		@box_scores = @player.box_scores.joins(:game).order('games.date')
		@team = @player.team
	end

	def new
		@box_score = BoxScore.new(player_id: @player.id)
	end

	def create
		bs_params = box_score_params.merge({player_id: @player.id, game_id: @game.id})
		@box_score = BoxScore.new(bs_params)
		if @box_score.save
			redirect_to team_player_box_scores_path(@player.team, @player)
		else
			render :new and return
		end
	end

	def edit
		@box_score = BoxScore.find(params[:id])
	end

	def update
		@box_score = BoxScore.find(params[:id])
		if @box_score.update_attributes(box_score_params)
			update_game
			redirect_to team_player_box_scores_path(@player.team, @player)
		else
			render :new and return
		end
	end

	private

	def box_score_params
		params.require(:box_score).permit(:total_points, :assists,
			:rebounds, :two_point_make, :two_point_attempt, :three_point_make,
			:three_point_attempt, :one_point_make, :one_point_attempt)
	end

	def validate_game
		if params[:box_score_date].blank?
			flash.now[:alert] = 'Please specify a game date'
			@box_score = BoxScore.new(player_id: @player.id)
			render :new and return
		end

		if params[:box_score_opponent].blank?
			flash.now[:alert] = 'Please specify a game opponent'
			@box_score = BoxScore.new(player_id: @player.id)
			render :new and return
		end
	end

	def update_game
		game_date = Date.strptime(params['box_score_date'], '%m/%d/%Y')
		@game = @box_score.game
		@game.update_attributes(opponent: params[:box_score_opponent], date: game_date)
	end

	def find_or_create_game
		game_date = Date.strptime(params['box_score_date'], '%m/%d/%Y')
		@game = Game.where(opponent: params[:box_score_opponent], date: game_date).last
		if @game.blank?
			@game = Game.create(opponent: params[:box_score_opponent], date: game_date)
		end
	end

	def get_player
		@player = Player.find_by_id(params[:player_id])
		unless @player
			redirect_to root_path and return
		end
	end
end
