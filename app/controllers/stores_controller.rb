class StoresController < ApplicationController
  def show
    @store = Store.find(params[:id])
    @films = @store.films
  end
end
