class CreateCustomer < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name

      t.timestamps
    end
  end
end
