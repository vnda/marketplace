class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :api_url
      t.string :api_user
      t.string :api_password
      t.string :token

      t.timestamps
    end
  end
end
