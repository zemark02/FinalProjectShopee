class CreateOrderLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_line_items do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.float   :price
    end
  end
end
