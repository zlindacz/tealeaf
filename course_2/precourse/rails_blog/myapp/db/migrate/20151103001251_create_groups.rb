class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_name
      t.string :user
      t.string :color

      t.timestamps null: false
    end
  end
end