class CreateResults < ActiveRecord::Migration[7.1]
  def change
    create_table :results do |t|
      t.references :flashcard_master, null: false, foreign_key: true
      t.datetime :learned_at, null: false
      t.boolean :result, null: false

      t.timestamps
    end

    add_index :results, :learned_at
    add_index :results, %i[flashcard_master_id learned_at], unique: true
  end
end
