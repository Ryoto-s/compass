class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :status, null: false

      t.timestamps
    end

    add_index :tags, %i[user_id name], unique: true
    add_index :tags, :name
  end
end
