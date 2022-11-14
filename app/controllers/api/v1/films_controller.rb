class Api::V1::FilmsController < ApplicationController
  def lean
    render json: json_response
  end

  def index
    render json: scope.map { |film| Api::V1::FilmPresenter.new(film).to_json }
  end

  private

  def json_response
    Film.all.map { |m| {id: m.id, title: m.title} }.to_json
  end

  def scope
    aux = if params[:language]
      language = Language.where(name: params[:language]).first
      Film.where(language_id: language.id).order("title asc")
    else
      Film
    end

    aux.select(:id, :title)
  end
end
