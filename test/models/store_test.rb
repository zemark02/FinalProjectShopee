# == Schema Information
#
# Table name: stores
#
#  id            :bigint           not null, primary key
#  address_store :string(255)
#  name          :string(255)
#  phone         :string(255)
#  rating        :float(24)
#  store_name    :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_stores_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
