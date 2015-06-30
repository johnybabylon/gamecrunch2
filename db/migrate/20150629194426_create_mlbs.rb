class CreateMlbs < ActiveRecord::Migration
  def change
    create_table :mlbs do |t|
      t.string :name
      t.text :team

      t.timestamps null: false
    end
  end
end
