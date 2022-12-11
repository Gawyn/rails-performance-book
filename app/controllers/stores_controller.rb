class StoresController < ApplicationController
  def show
    @store = Store.find(params[:id])
    @films = @store.films
  end

  def index
    @films = Film.all
  end
end
