class CreateCustomerStatsProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_stats_profiles do |t|
      t.integer :customer_id
      t.text :data

      t.timestamps
    end
  end
end
