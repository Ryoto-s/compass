class CreateUserDefs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_defs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :sur_name, null: false
      t.string :first_phonetic
      t.string :sur_phonetic
      t.date :date_of_birth, null: false
      t.string :sex
      t.boolean :status, null: false

      t.timestamps
    end

    add_index :user_defs, :sur_name
    add_index :user_defs, :first_name
    add_index :user_defs, :sur_phonetic
    add_index :user_defs, :first_phonetic
  end
end
