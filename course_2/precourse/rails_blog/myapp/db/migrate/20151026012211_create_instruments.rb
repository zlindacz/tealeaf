class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :user, index: true, foreign_key: true
      t.string :instrument
      t.integer :years_of_playing

      t.timestamps null: false
    end
  end
end
