class Api::V1::FilmsController < ApplicationController
  include Kaminari::Helpers::UrlHelper

  def lean
    render json: json_response
  end

  def index
    render json: {
      films: scope.select(:id, :title).map do |film| 
        Api::V1::FilmPresenter.new(film).to_json.tap do |film_json|
          if params['store_id']
            rentals_url = api_v1_store_film_rentals_url(film_id: film.id, store_id: params['store_id'])
            film_json.merge!(rentals_url: rentals_url)
          end
        end
      end,
      count: scope.count,
      previous_page: prev_page_url(scope),
      next_page: next_page_url(scope),
      total_pages: scope.total_pages
    }
  end

  def rentals
    inventory_ids = Inventory.where(film_id: params[:film_id], store_id: params[:store_id]).pluck(:id)
    rentals = Rental.where(inventory_id: inventory_ids).includes(:film, :customer)

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  private

  def json_response
    Film.all.map { |m| {id: m.id, title: m.title} }.to_json
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

    aux.page(params[:page]).per(params[:per_page])
  end
end
