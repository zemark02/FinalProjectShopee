# == Schema Information
#
# Table name: contains
#
#  id                    :bigint           not null, primary key
#  quantity_product_cart :integer          not null
#  cart_id               :integer          not null
#  product_id            :integer          not null
#
class Contain < ApplicationRecord
  belongs_to :cart  ,  class_name:"Cart"
  belongs_to :product , class_name:"Product"
end
