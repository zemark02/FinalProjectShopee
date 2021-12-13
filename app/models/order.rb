# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
class Order < ApplicationRecord
  has_many :match_order_line_items ,foreign_key: :order_id ,class_name:"OrderLineItem"
  belongs_to :user ,class_name:"User"

end
