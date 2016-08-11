class AddRemoteIdToObjects < ActiveRecord::Migration
  def change
    add_column :box_scores, :device_id, :integer
    add_column :games, :device_id, :integer
    add_column :players, :device_id, :integer
    add_column :teams, :device_id, :integer
    add_column :users, :device_id, :integer
  end
end
