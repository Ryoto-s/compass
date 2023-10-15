class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.boolean :status, null: false

      t.timestamps
    end
  end
end
