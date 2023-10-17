class CreateTagReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :tag_references do |t|
      t.references :word_book_master, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
