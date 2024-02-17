class ReplaceIndexOfResult < ActiveRecord::Migration[7.1]
  def change
    add_index :results, %i[flashcard_master_id result updated_at user_id], unique: true
  end
end
