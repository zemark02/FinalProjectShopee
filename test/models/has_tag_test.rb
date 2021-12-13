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
require "test_helper"

class HasTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
