# == Schema Information
#
# Table name: has_tags
#
#  id         :bigint           not null, primary key
#  product_id :bigint
#  tag_id     :bigint
#
# Indexes
#
#  index_has_tags_on_product_id  (product_id)
#  index_has_tags_on_tag_id      (tag_id)
#
class HasTag < ApplicationRecord
  belongs_to :product  ,  class_name:"Product"
  belongs_to :tag  ,  class_name:"Tag"
end
