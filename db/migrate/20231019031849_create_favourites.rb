class CreateFavourites < ActiveRecord::Migration[7.1]
  def change
    create_table :favourites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :flashcard_master, null: false, foreign_key: true

      t.timestamps
    end

    add_index :favourites, %i[user_id flashcard_master_id], unique: true
  end
end
