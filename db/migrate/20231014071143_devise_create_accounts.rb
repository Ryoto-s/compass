# frozen_string_literal: true

class DeviseCreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :last_sign_in_at

      ## Confirmable
      t.datetime :confirmed_at

      t.timestamps null: false
    end

    add_index :accounts, :email,                unique: true
    add_index :accounts, :reset_password_token, unique: true
    # add_index :accounts, :confirmation_token,   unique: true
    # add_index :accounts, :unlock_token,         unique: true
  end
end
