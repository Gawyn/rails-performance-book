class Api::V1::FilmPresenter < Api::V1::Presenter

  private

  def as_json
    {
      id: resource.id,
      title: resource.title
    }
  end
end
