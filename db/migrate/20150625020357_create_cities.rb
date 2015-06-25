class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.references :country, index: true

      t.timestamps null: false
    end
    add_foreign_key :cities, :countries
  end
end
