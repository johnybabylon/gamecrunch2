class AddNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number, :int
  end
end
