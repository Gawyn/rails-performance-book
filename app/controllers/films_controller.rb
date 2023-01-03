class FilmsController < ApplicationController
  def show
    @film = Film.find(params[:id])
  end

  def index
    @films = Film.includes(:language, :stores)
  end
end
