class MainController < ApplicationController
	skip_before_action :authenticate_user!

  def index
  end

  def ping
  	render text: "pong"
  end
end
