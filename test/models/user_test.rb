# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  address         :string(255)
#  birthdate       :date
#  email           :string(255)
#  gender          :string(255)
#  name            :string(255)
#  password_digest :string(255)
#  phone           :string(255)
#  username        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
