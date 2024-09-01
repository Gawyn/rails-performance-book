class StoresController < ApplicationController
  def show
    @store = Store.find(params[:id])
    @films = @store.films
  end

  def index
    response.headers["Cache-Control"] = "max-age=60"
    @stores = Store.all
  end
end
