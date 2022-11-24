class AddTitleIndexToFilms < ActiveRecord::Migration[7.0]
  def change
    add_index(:films, :title)
  end
end
