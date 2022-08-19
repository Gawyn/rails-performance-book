class AddLanguageIdToFilm < ActiveRecord::Migration[7.0]
  def change
    add_column :films, :language_id, :integer
  end
end
