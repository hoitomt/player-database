class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :opponent
      t.datetime :date
      t.integer :team_id

      t.timestamps null: false
    end
  end
end
