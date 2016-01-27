class DeviseTokenAuthCreateUsers < ActiveRecord::Migration
  def change
      ## Required
      change_column_null :users, :provider, false
      change_column_null :users, :uid, false, ""

      ## Trackable
      #t.string   :current_sign_in_ip
      #t.string   :last_sign_in_ip

      ## Confirmable
      add_column :users, :confirmation_token, :string
      add_column :users, :confirmed_at, :datetime
      add_column :users, :confirmation_sent_at, :datetime
      add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

      ## User Info
      add_column :users, :name, :string
      add_column :users, :nickname, :string
      add_column :users, :image, :string

      ## Tokens
      add_column :users, :tokens, :text

    add_index :users, [:uid, :provider],     :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end
end
