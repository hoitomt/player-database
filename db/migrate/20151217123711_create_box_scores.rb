class CreateBoxScores < ActiveRecord::Migration
  def change
    create_table :box_scores do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :one_point_attempt
      t.integer :one_point_make
      t.integer :two_point_attempt
      t.integer :two_point_make
      t.integer :three_point_attempt
      t.integer :three_point_make
      t.integer :turnovers
      t.integer :assists
      t.integer :fouls
      t.integer :rebounds

      t.timestamps null: false
    end
  end
end
