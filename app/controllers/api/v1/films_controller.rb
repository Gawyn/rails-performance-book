require 'kaminari/helpers/helper_methods'

class Api::V1::FilmsController < ApplicationController
  include Kaminari::Helpers::UrlHelper

  def lean
    render json: json_response
  end

  def index
    if params[:cbp]
      results = cbp_scope(Film, params[:cursor])
      response = {
        films: full_films_json_response
      }

      if results.count > 0
        response[:previous_page] = api_v1_films_url(cbp: true, cursor: generate_cursor('id', results&.first&.id, '<'))
        response[:next_page] = api_v1_films_url(cbp: true, cursor: generate_cursor('id', results&.last&.id, '>'))
      end

      render json: response
    else
      render json: {
        films: full_films_json_response,
        count: scope.count,
        previous_page: prev_page_url(scope),
        next_page: next_page_url(scope),
        total_pages: scope.total_pages
      }
    end
  end

  def rentals
    inventory_ids = Inventory.where(film_id: params[:film_id], store_id: params[:store_id]).pluck(:id)
    rentals = Rental.where(inventory_id: inventory_ids).includes(:film, :customer)

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  private

  def full_films_json_response
    if params['store_id'] && params[:include]&.include?('rentals')
      films = scope.includes(:rentals).where(inventories: { "store_id" => params[:store_id] })

      films.map do |film|
        json_rentals = film.rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json(exclude: [:movie_name]) }
        Api::V1::FilmPresenter.new(film).to_json.merge(rentals: json_rentals)
      end
    else
      scope.select(:id, :title).map do |film|
        Api::V1::FilmPresenter.new(film).to_json
      end
    end
  end

  def json_response
    Film.all.map { |m| {id: m.id, title: m.title} }.to_json
  end

  def scope
    @scope ||= begin
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
end
