class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy showFollow feed cart follow]
  before_action :landing_page, only: [:new,:index ,:create ]
  after_action :set_default_avatar , only: %i[create]
  before_action :logged_in , only: %i[index show profile feed showFollow follow cart updateInfo updateAddress updatePassword]
  before_action :logged_in_for_buy ,only: %i[cart checkout updateCart]
  # GET /users or /users.json
  def index
    @users = User.all
  end


  def logged_in_for_buy
    if(session[:user_id] == nil)
      redirect_to "/login" ,notice:"Please login"
    end
  end




  # GET /users/new
  def new
    @user = User.new
  end



  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    check_username = @user.check_username
    check_email = @user.check_email
    check_password_confimation = @user.check_password_confimation(params[:user][:password],params[:user][:password_confirmation])
    respond_to do |format|
      if check_password_confimation && check_email && check_username && @user.save
        Cart.create(user_id:@user.id)
        format.html { redirect_to '/login' , notice: "User was successfully created."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def updateInfo
    @user = User.find(session[:user_id])
    @userEditProfile = User.find(session[:user_id])
    @userEditAddress = User.find(session[:user_id])
    @userEditPassword = User.find(session[:user_id])
    check_update_email = @userEditProfile.check_update_email(session[:user_id],params[:user][:email])
    check_update_user = @userEditProfile.check_update_username(session[:user_id],params[:user][:username])
    @userEditProfile.email = params[:user][:email]
    @userEditProfile.username = params[:user][:username]


    respond_to do |format|
      if check_update_user && check_update_email &&  @userEditProfile.update(user_params_update_info)
        format.html { redirect_to request.referrer , notice: "Profile was successfully changed." }
      else
        format.html { render :profile, status: :unprocessable_entity }
      end
    end

  end

  def updateAddress
    @user = User.find(session[:user_id])
    @userEditProfile = User.find(session[:user_id])
    @userEditAddress = User.find(session[:user_id])
    @userEditPassword = User.find(session[:user_id])
    @userEditAddress.address = params[:user][:address]


    respond_to do |format|
      if @userEditAddress.save
        format.html { redirect_to request.referrer , notice: "Address was successfully changed."}
      end
    end
  end

  def updatePassword
    @user = User.find(session[:user_id])
    @userEditProfile = User.find(session[:user_id])
    @userEditAddress = User.find(session[:user_id])
    @userEditPassword = User.find(session[:user_id])
    check_update_password = @userEditPassword.check_update_password(params[:user][:password],params[:user][:password_confirmation])
    @userEditPassword.password = params[:user]["password"]

    respond_to do |format|
      if check_update_password && @userEditPassword.save
        format.html { redirect_to request.referrer , notice: "Passord was successfully changed."}
      else
        format.html { render :profile, status: :unprocessable_entity }
      end
    end


  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def profile

    @user = User.find(params[:id])
    @userEditProfile = User.find(params[:id])
    @userEditAddress = User.find(params[:id])
    @userEditPassword = User.find(params[:id])


  end
  def feed
    @following = @user.followings
    @getTagAndProduct = @user.getProductFromStoreFollowing
  end



  def followUpdate





    @check_follow = ActiveModel::Type::Boolean.new.cast(params[:checkFollow])
    @otherShop_id = params[:shopId]

    if(@check_follow)
      ActiveRecord::Base.connection.execute("DELETE FROM follows WHERE followee_id=#{session[:user_id]} and following_id=#{@otherShop_id}")
      redirect_to request.referrer
    else
      Follow.create(followee_id:session[:user_id],following_id:@otherShop_id)
      redirect_to request.referrer
    end

  end

  def updateCart
    @user = User.find(session[:user_id])
    @product = Product.find(params[:product_id])
    @quantity_products = params[:quantity]
    Contain.create(quantity_product_cart:@quantity_products ,cart_id:@user.cart.id,product_id:@product.id )
    redirect_to "/cart/#{session[:user_id]}"

  end

  def cart
    @getProductFromCart = @user.getProductFromCart
    @sum = totalProduct(@getProductFromCart)
    @checkout = @getProductFromCart.to_s
  end

  def follow
    @userFollowing = @user.followings
    @followings = @user.followings

  end

  def checkout
    @user = User.find(session[:user_id])
    product = JSON(params[:checkout])
    order = Order.create(user_id:@user.id)
    product.each do |p_id,p_name,p_desc,p_quantity,p_price|
      OrderLineItem.create(product_id:p_id,order_id:order.id,quantity:p_quantity,price:p_price)
      @product = Product.find(p_id)
      @product.quantity = @product.quantity - p_quantity
      @product.save
    end



    @user.cart.match_products.destroy_all
    redirect_to request.referrer



  end

  def deleteProductFromCart
    contain = Contain.find(params[:id])
    contain.destroy
    redirect_to request.referrer

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :email, :name, :address, :phone, :gender, :birthdate , :password_confirmation,:avatar)
    end

    def user_params_update_info
      params.require(:user).permit(:username, :email, :name, :phone, :gender, :birthdate ,:avatar)
    end

    def set_default_avatar
      if(!@user.avatar.attached?)
        @user.avatar.attach(
          io: File.open(
            Rails.root.join(
              'app','assets','images' ,'xxx.png'
            )
          ),
          filename: 'xxx.png',
          content_type: 'image/png'
        )
        end
    end

    def totalProduct(product)
      sum = 0
      product.each do p
        if(p["total"] != nil )
          sum = sum + p["total"]
        end
      end
      return sum
    end

    def logged_in
      @user = User.find_by_id(params[:id])
      if(@user && session[:user_id] == @user.id)
        return true
      else
        session[:user_id] = nil
        redirect_to "/login" , notice: "Please login"
      end
    end
end
