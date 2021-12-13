# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  tagname    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :match_products, foreign_key: :tag_id , class_name:"HasTag"
  has_many :products , through: :match_products

end
