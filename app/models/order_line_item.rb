# == Schema Information
#
# Table name: order_line_items
#
#  id         :bigint           not null, primary key
#  price      :float(24)
#  quantity   :integer
#  order_id   :integer
#  product_id :integer
#
class OrderLineItem < ApplicationRecord
  belongs_to :order,class_name:"Order"
  belongs_to :product,class_name:"Product"
  has_one:match_rate ,foreign_key: :order_line_item_id , class_name:"Rate"

end
