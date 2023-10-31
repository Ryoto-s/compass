class CreateWordImages < ActiveRecord::Migration[7.1]
  def change
    create_table :word_images do |t|
      t.references :word_book_master, null: false, foreign_key: true, index: { unique: true }
      t.text :image_path, null: false

      t.timestamps
    end
  end
end
