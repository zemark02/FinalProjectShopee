# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :string(255)
#  name        :string(255)
#  price       :float(24)
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  store_id    :bigint           not null
#
# Indexes
#
#  index_products_on_store_id  (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (store_id => stores.id)
#
class Product < ApplicationRecord
  belongs_to :store
  has_many_attached :img_products

  has_many :match_tags,foreign_key: :product_id , class_name:"HasTag"
  has_many :tags ,through: :match_tags

  has_many :match_carts,foreign_key: :product_id , class_name:"Contain"
  has_many :carts ,through: :match_carts

  has_many:order_line_items ,foreign_key: :product_id , class_name:"OrderLineItem"
  has_many:rates ,through: :order_line_items

  def self.search(name)
    query = <<-SQL
    SELECT *
    FROM products
    WHERE name LIKE '%#{name}%'
    SQL
    result = Product.find_by_sql(query)
    # result = ActiveRecord::Base.connection.execute(query)
    return result
  end

  def getScoreProduct
    query = <<-SQL
    SELECT SUM(r.rate_score) ,count(*)
    FROM order_line_items olt , products p , rates r
    WHERE olt.product_id = p.id AND #{self.id} = p.id AND r.order_line_item_id = olt.id
    SQL
    result = ActiveRecord::Base.connection.execute(query)
    arr = result.to_a
    if(arr.length == 0 || arr[0]["sum"] == nil || arr[0]["count"] == 0)
      result = 0
    else
      result = (Float(arr[0]["sum"]) / arr[0]["count"]).round(1)

    end

    return result

  end

  def getNumComment
    query = <<-SQL
    SELECT count(*)
    FROM order_line_items oli,rates r
    WHERE oli.product_id = #{self.id} AND  r.order_line_item_id = oli.id
    SQL

    result = ActiveRecord::Base.connection.execute(query)
    arr = result.to_a
    if(arr.length == 0 || arr[0].length == 0 || arr[0][0] == nil)
      return 0
    end
    return arr[0][0]
  end





end
