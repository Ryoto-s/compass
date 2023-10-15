class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.references :account, null: false, foreign_key: true
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :phonetic
      t.date :date_of_birth, null: false
      t.string :sex
      t.boolean :status, null: false

      t.timestamps
    end

    add_index :users, :account_id
    add_index :users, :last_name
    add_index :users, :first_name
    add_index :users, :phonetic
  end
end
