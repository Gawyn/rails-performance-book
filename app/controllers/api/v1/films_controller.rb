require 'kaminari/helpers/helper_methods'

class Api::V1::FilmsController < ApplicationController
  include Kaminari::Helpers::UrlHelper

  def lean
    if params[:cbp]
      results = cbp_scope(Film, params[:cursor])
      response = {
        films: results.pluck(:id, :title).map { |m| {id: m.first, title: m.last} }
      }

      if results.count > 0
        response[:previous_page] = api_v1_films_url(
          cbp: true,
          cursor: generate_cursor('id', results&.first&.id, '<')
        )
        response[:next_page] = api_v1_films_url(
          cbp: true,
          cursor: generate_cursor('id', results&.last&.id, '>')
        )
      end

      render json: response
    else
      render json: json_response
    end
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
    cached_response(expiration_key) do
      scope.map { |film| decorated_film(film) }.to_json
    end
  end

  def decorated_film(film)
    presented_film = Api::V1::FilmPresenter.new(film).to_json

    if params['store_id']
      rentals_url = api_v1_store_film_rentals_url(
        film_id: film.id, store_id: params['store_id']
      )
      presented_film[:rental_url] = rentals_url
    end

    presented_film
  end

  def json_response
    films = paginated_scope.pluck(:id, :title).map { |m| {id: m.first, title: m.last} }
    # If you didn't complete the Data Access chapter, this would look like:
    # paginated_scope.map { |m| {id: m.id, title: m.title}.to_json

    {films: films}.merge(paginated_scope_decorations).to_json
  end

  def paginated_scope
    Film.page(params[:page]).per(params[:per_page])
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

  def paginated_scope_decorations
    {
      count: paginated_scope.total_count,
      previous_page: prev_page_url(paginated_scope),
      next_page: next_page_url(paginated_scope),
      total_pages: paginated_scope.total_pages
    }
  end
end
