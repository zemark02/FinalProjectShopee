# == Schema Information
#
# Table name: follows
#
#  id           :bigint           not null, primary key
#  followee_id  :integer          not null
#  following_id :integer          not null
#
require "test_helper"

class FollowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
