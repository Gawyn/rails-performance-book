class AddIndexOnCreatedAtInFilms < ActiveRecord::Migration[7.0]
  def change
    add_index(:films, [:created_at, :id])
  end
end
