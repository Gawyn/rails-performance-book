class Api::V1::FilmsController < ApplicationController
  def lean
    render json: json_response
  end

  def index
    render json: cached_index_response
  end

  def rentals
    inventory_ids = Inventory.where(film_id: params[:film_id], store_id: params[:store_id]).pluck(:id)
    rentals = Rental.where(inventory_id: inventory_ids).includes(:film, :customer)

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  private

  def cached_index_response
    expiration_key = "#{Film.count}-#{Film.maximum(:updated_at)}"
    aux = cached_response(expiration_key) do
      scope.map { |film| Api::V1::FilmPresenter.new(film).to_json }
    end
  end

  def json_response
    Film.pluck(:id, :title).map { |m| {id: m.first, title: m.last} }.to_json
  end

  def scope
    if params[:language]
      language = Language.where(name: params[:language]).first
      Film.where(language_id: language.id).order("title asc")
    else
      Film
    end.page(params[:page]).per(params[:per_page])
  end
end
