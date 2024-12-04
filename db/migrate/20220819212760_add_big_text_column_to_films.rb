class AddBigTextColumnToFilms < ActiveRecord::Migration[7.0]
  def change
    add_column :films, :big_text_column, :text
  end
end
