class AddTotalPointsToBoxScore < ActiveRecord::Migration
  def change
	  add_column :box_scores, :total_points, :integer
  end
end
