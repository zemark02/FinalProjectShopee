# == Schema Information
#
# Table name: carts
#
#  id      :bigint           not null, primary key
#  user_id :bigint           not null
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Cart < ApplicationRecord
  belongs_to :user
  has_many :match_products,foreign_key: :cart_id , class_name:"Contain"
  has_many :products ,through: :match_products
end
