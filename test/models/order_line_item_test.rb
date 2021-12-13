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
require "test_helper"

class OrderLineItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
