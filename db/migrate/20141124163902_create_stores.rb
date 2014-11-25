class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :api_url
      t.string :api_user
      t.string :api_password
      t.string :token
      t.string :ml_token
      t.string :ml_app_id
      t.string :ml_secret
      t.string :ml_refresh_token

      t.timestamps
    end
  end
end
