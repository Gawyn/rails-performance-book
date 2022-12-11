class FilmsController < ApplicationController
  def show
    @film = Film.find(params[:id])
  end
end
