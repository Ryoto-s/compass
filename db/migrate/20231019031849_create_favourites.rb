class CreateFavourites < ActiveRecord::Migration[7.1]
  def change
    create_table :favourites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :word_book_master, null: false, foreign_key: true

      t.timestamps
    end

    add_index :favourites, %i[user_id word_book_master_id], unique: true
  end
end
