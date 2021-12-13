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
class Store < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  has_many :products

  has_many :match_followers, foreign_key: :following_id , class_name:"Follow"
  has_many :followees , through: :match_followers

  def getTagAndProduct
    query = <<-SQL
    SELECT t.tagname , p.id , p.name ,p.price,p.description,p.quantity,p.updated_at
    FROM products p , has_tags ht , tags t
    WHERE p.id = ht.product_id and ht.tag_id = t.id and "#{self.id}" = p.store_id
    order by t.tagname
    SQL
    # result = Product.find_by_sql(query)
    result = ActiveRecord::Base.connection.execute(query)

    arr = result.to_a
    result = Hash.new
    (0..arr.count-1).to_a.each do |index|
      arr[index][arr[index].count-1] = arr[index].last.strftime("%B #{arr[index].last.day.ordinalize}, %Y")
    end
    arr.each do |res|
      if(result.has_key?res[0])
        result[res[0]].push(res[1..])
      else
        result[res[0]] = [res[1..]]
      end
    end

    return result
  end

  def getScoreShop
    query = <<-SQL
    SELECT sum(r.rate_score) , count(*)
    FROM order_line_items oli , rates r ,products p , stores s
    WHERE  oli.product_id = p.id AND  s.id = #{self.id} AND r.order_line_item_id = oli.id AND p.store_id = s.id
    SQL

    result = ActiveRecord::Base.connection.execute(query)

    arr = result.to_a

    if(arr[0][1] == 0)
      result = 0
    else
      result = (Float(arr[0][0]) / arr[0][1]).round(1)
    end

    return result
  end

  def getSaleRecord
    query = <<-SQL
    SELECT oli.product_id,   SUM(oli.quantity)
    FROM order_line_items oli , stores s , products p
    WHERE  oli.product_id = p.id AND  s.id = #{self.id} AND  p.store_id = s.id
    GROUP BY oli.product_id;
    SQL
    result = ActiveRecord::Base.connection.execute(query)

    arr = result.to_a
    return result

  end

end
