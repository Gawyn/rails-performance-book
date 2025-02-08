class StoresController < ApplicationController
  def show
    @store = Store.find(params[:id])
    @films = @store.films.eager_load(:language)
  end

  def index
    @stores = Store.all
  end
end
