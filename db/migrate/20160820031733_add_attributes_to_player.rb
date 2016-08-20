class AddAttributesToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :height_feet, :integer
    add_column :players, :height_inches, :integer
    add_column :players, :position, :string
    add_column :players, :school, :string
    add_column :players, :year, :string
  end
end
