class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.float :rating
      t.string :store_name
      t.string :phone
      t.string :address_store
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
