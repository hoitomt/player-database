class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @teams = current_user.teams
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.create(team_params)
    if @team.valid?
      flash[:success] = "#{@team.name} has been created"
      redirect_to teams_path
    else
      flash[:error] = "You are missing something"
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.update_attributes(team_params)
    if @team.valid?
      flash[:success] = "#{@team.name} has been created"
      redirect_to teams_path
    else
      flash[:error] = "You are missing something"
      render :new
    end
  end

  def destroy
    team = Team.find(params[:id])
    team.destroy
    flash[:success] = "Team has been destroyed"
    redirect_to teams_path
  end

  private

  def team_params
    params.require(:team).permit(:name, :slug)
  end
end