class CreateContains < ActiveRecord::Migration[6.1]
  def change
    create_table :contains do |t|
      t.integer :cart_id , null: false , foreign_key:true
      t.integer :product_id , null: false , foreign_key:true
      t.integer :quantity_product_cart ,null:false
    end
  end
end
