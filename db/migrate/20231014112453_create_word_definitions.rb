class CreateWordDefinitions < ActiveRecord::Migration[7.1]
  def change
    create_table :word_definitions do |t|
      t.references :word_book_master, null: false, foreign_key: true, index: { unique: true }
      t.string :word, null: false
      t.text :answer, null: false
      t.string :language

      t.timestamps
    end

    add_index :word_definitions, :word
  end
end
