class RemoveLearnedAtFromResult < ActiveRecord::Migration[7.1]
  def change
    remove_column :results, :learned_at, :datetime
  end
end
