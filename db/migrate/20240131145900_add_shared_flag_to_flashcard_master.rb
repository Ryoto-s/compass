class AddSharedFlagToFlashcardMaster < ActiveRecord::Migration[7.1]
  def change
    add_column :flashcard_masters, :shared_flag, :integer, null: false, default: 0
  end
end
