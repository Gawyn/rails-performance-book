class Api::V1::FilmsController < ApplicationController
  def lean
    render json: json_response
  end

  def index
    render json: scope.map { |film| Api::V1::FilmPresenter.new(film).to_json }
  end

  def rentals
    inventory_ids = Inventory.where(film_id: params[:film_id], store_id: params[:store_id]).pluck(:id)
    rentals = Rental.where(inventory_id: inventory_ids).includes(:film, :customer)

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  private

  def json_response
    Film.pluck(:id, :title).map { |m| {id: m.first, title: m.last} }.to_json
  end

  def scope
    aux = if params[:store_id]
      @store = Store.find(params[:store_id])
      @store.films
    else
      Film
    end

    if params[:language]
      language = Language.where(name: params[:language]).first
      aux = Film.where(language_id: language.id).order("title asc")
    end

    aux.select(:id, :title, :updated_at)
  end
end
