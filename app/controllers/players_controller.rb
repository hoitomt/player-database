class PlayersController < ApplicationController
	before_action :get_team

	def index
		@players = @team.players
	end

	def show
		@player = Player.find(params[:id])
	end

	def new
		@player = @team.players.build
	end

	def create
		@player = @team.players.build(player_params)
		if @player.save
			flash[:notice] = "Player has been created"
			redirect_to team_players_path(@team)
		else
			flash[:alert] = "There was an error #{@player.error_messages}"
			render :new
		end
	end

	def edit
		@player = Player.find(params[:id])
	end

	def update
		@player = Player.find(params[:id])
		if @player.update_attributes(player_params)
			flash[:notice] = "Player has been updated"
			redirect_to team_players_path(@team)
		else
			flash[:alert] = "There was an error #{@player.error_messages}"
			render :new
		end
	end

	private

	def player_params
		params.require(:player).permit(:number, :name)
	end

	def get_team
		@team = Team.find_by_id(params[:team_id])
		unless @team
			redirect_to root_path and return
		end
	end
end
