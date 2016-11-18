class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    t_params = team_params.merge({user_id: current_user.id})
    @team = Team.create(t_params)
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
