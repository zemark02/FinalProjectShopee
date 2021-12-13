class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.string :comment
      t.integer :rate_score
      t.integer :order_line_item_id , null: false , foreign_key:true
      t.integer :user_id , null: false , foreign_key:true
      t.timestamps
    end
  end
end
