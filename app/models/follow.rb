# == Schema Information
#
# Table name: follows
#
#  id           :bigint           not null, primary key
#  followee_id  :integer          not null
#  following_id :integer          not null
#
class Follow < ApplicationRecord
  belongs_to :followee  ,  class_name:"User"
  belongs_to :following , class_name:"Store"
end
