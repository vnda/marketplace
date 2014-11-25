class CreateMlProducts < ActiveRecord::Migration
  def change
    create_table :ml_products do |t|
      t.references :store, index: true
      t.string :vnda_id
      t.string :vnda_sku
      t.string :ml_id

      t.timestamps
    end
  end
end
