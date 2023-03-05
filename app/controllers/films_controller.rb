class FilmsController < ApplicationController
  def show
    @film = Film.find(params[:id])
  end

  def index
    @films = Film.includes(:language, :stores)
  end

  def create
    @film = Film.new params[:film]
    @film.save
    redirect_to film_path(@film)
  end
end
