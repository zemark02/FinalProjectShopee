# == Schema Information
#
# Table name: contains
#
#  id                    :bigint           not null, primary key
#  quantity_product_cart :integer          not null
#  cart_id               :integer          not null
#  product_id            :integer          not null
#
require "test_helper"

class ContainTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
