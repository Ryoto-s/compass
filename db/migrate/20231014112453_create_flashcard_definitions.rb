class CreateFlashcardDefinitions < ActiveRecord::Migration[7.1]
  def change
    create_table :flashcard_definitions do |t|
      t.references :flashcard_master, null: false, foreign_key: true, index: { unique: true }
      t.string :word, null: false
      t.text :answer, null: false
      t.string :language

      t.timestamps
    end

    add_index :flashcard_definitions, :word
  end
end
