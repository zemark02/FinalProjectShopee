# == Schema Information
#
# Table name: rates
#
#  id                 :bigint           not null, primary key
#  comment            :string(255)
#  rate_score         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_line_item_id :integer          not null
#  user_id            :integer          not null
#
1# == Schema Information
#
# Table name: rates
#
#  id                 :bigint           not null, primary key
#  comment            :string(255)
#  rate_score         :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_line_item_id :integer          not null
#  user_id            :integer          not null
#
class Rate < ApplicationRecord
  belongs_to :order_line_item ,class_name:"OrderLineItem"
  belongs_to :user , class_name:"User"

end
