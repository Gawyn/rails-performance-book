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
    expire_page controller: 'home', action: "home"
    redirect_to film_path(@film)
  end
end
