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
class User < ApplicationRecord
  has_one_attached :avatar
  has_secure_password

  has_one :store
  has_many :orders

  has_many :match_followees ,foreign_key: :followee_id , class_name:"Follow"
  has_many :followings ,through: :match_followees

  has_one :cart ,class_name:"Cart"




  def check_password_confimation(password,password_confirmation)
    if(password == password_confirmation)
      return true
    else
      errors.add(:password,"doesn't match with password confirmation")
      errors.add(:password_confirmation,"doesn't match with password ")
      return false
    end
  end

  def check_update_email(id,email)
    if(User.find_by_email(email))
       u = User.find_by_email(email)
       if(u.id != id)
         errors.add(:email,"already exists")
         return false
       else
         return true
       end
    else
      return true
    end
  end

  def check_update_username(id,username)
    if(User.find_by_username(username))
       u = User.find_by_username(username)
       if(u.id != id)
         errors.add(:username,"already exists")
         return false
       else
         return true
       end
    else
      return true
    end
  end

  def check_update_password(password,password_confirmation)
    if(password != password_confirmation)
      errors.add(:password,"doesn't match with password confirmation")
      errors.add(:password_confirmation,"doesn't match with password ")
      return false
    else
      return true
    end
  end

  def check_email
    if(User.find_by_email(self.email))
      errors.add(:email, "already exists")
      return false
    end
    return true
  end

  def check_username
    if(User.find_by_username(self.username))
      errors.add(:username, "already exists")
      return false
    end
    return true
  end


  def login
    @user = User.find_by_username(self.username)
    if(@user)
      if(@user.authenticate(self.password))
        self.id = @user.id
        return true
      else
        errors.add(:username)
        errors.add(:password)
        false
      end
    else
      errors.add(:username)
      errors.add(:password)
      false
    end
  end

  def getProductFromStoreFollowing
    query = <<-SQL
    SELECT t.tagname , p.id , p.name ,p.price,p.description,p.quantity,p.updated_at
    FROM products p , has_tags ht , tags t , follows f
    WHERE p.id = ht.product_id and ht.tag_id = t.id and f.following_id = p.store_id and f.followee_id = #{self.id}
    order by t.tagname
    SQL

    result = ActiveRecord::Base.connection.execute(query)

    arr = result.to_a
    result = Hash.new
    (0..arr.count-1).to_a.each do |index|
            puts "----------------------------------------------1.-----  #{arr[index]}----------------------------------"
      puts "----------------------------------------------2.-----  #{arr[index]["updated_at"]}----------------------------------"

      arr[index]["updated_at"] = arr[index]["updated_at"].strftime("%B #{arr[index]["updated_at"].day.ordinalize}, %Y")
    end
    arr.each do |res|
      if(result.has_key?res['tagname'])
        result[res['tagname']].push(res)
      else
        result[res['tagname']] = [res]
      end
    end

    return result
  end

  def getProductFromCart
    query = <<-SQL
    SELECT product.id,product.name,product.description,contain.quantity_product_cart,product.price *  contain.quantity_product_cart AS total,contain.id AS contain_id
    FROM products product , carts cart , contains contain
    WHERE cart.user_id = #{self.id}  AND contain.cart_id = cart.id AND contain.product_id = product.id

    SQL

    result = ActiveRecord::Base.connection.execute(query)
    arr = result.to_a
    return arr

  end

end
