class AddTitleIndexToFilms < ActiveRecord::Migration[8.0]
  def change
    add_index(:films, :title)
  end
end
