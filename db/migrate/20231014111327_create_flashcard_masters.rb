class CreateFlashcardMasters < ActiveRecord::Migration[7.1]
  def change
    create_table :flashcard_masters do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.boolean :use_image, null: false
      t.boolean :input_enabled, null: false
      t.boolean :status, null: false

      t.timestamps
    end
  end
end
