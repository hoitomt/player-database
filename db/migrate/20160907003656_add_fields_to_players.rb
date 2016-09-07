class AddFieldsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :athletic_accomplishments, :text
    add_column :players, :colleges_interested, :text
    add_column :players, :gpa, :string
  end
end
