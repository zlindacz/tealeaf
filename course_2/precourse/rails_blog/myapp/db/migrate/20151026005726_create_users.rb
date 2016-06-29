class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.has_many :posts, index: true
      t.string :name, primary_key: true
      t.string :email

      t.timestamps null: false
    end
  end
end
