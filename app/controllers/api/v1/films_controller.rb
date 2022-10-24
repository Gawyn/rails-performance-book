class Api::V1::FilmsController < ApplicationController
  def lean
    render json: json_response
  end

  private

  def json_response
    Film.all.map { |m| {id: m.id, title: m.title} }.to_json
  end
end
