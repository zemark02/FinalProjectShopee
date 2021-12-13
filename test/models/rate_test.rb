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
require "test_helper"

class RateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
