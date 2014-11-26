class AddLastUpdateToStore < ActiveRecord::Migration
  def change
    add_column :stores, :last_update, :timestamp
  end
end
