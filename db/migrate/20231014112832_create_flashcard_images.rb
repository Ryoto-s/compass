class CreateFlashcardImages < ActiveRecord::Migration[7.1]
  def change
    create_table :flashcard_images do |t|
      t.references :flashcard_master, null: false, foreign_key: true, index: { unique: true }
      t.text :image, null: false

      t.timestamps
    end
  end
end
