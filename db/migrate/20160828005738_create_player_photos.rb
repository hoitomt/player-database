class CreatePlayerPhotos < ActiveRecord::Migration
  def change
    create_table :player_photos do |t|
      t.integer :player_id
      t.boolean :profile_photo
      t.string  :photo

      t.timestamps null: false
    end
  end
end
