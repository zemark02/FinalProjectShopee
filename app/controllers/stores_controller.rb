class StoresController < ApplicationController
  before_action :set_store, only: %i[ show edit update destroy ]
  after_action :set_default_avatar , only: %i[create]
  before_action :logged_in_for_buy ,except: %i[]


  def logged_in_for_buy
    if(session[:user_id] == nil)
      redirect_to "/login" ,notice:"Please login"
    end
  end

  # GET /stores or /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1 or /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store.new

  end


  # GET /stores/1/edit
  def edit
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)
    @store.save
    session[:myStore] = @store.id
    redirect_to "/feed/#{session[:user_id]}"
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    @store.update(store_params)
    redirect_to request.referrer


  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end

  def myStore
    if(check_has_store)
      @store = User.find(session[:user_id]).store
      @product = Product.new
      @saleRecord = @store.getSaleRecord
    else
      @store = Store.new
      render :new
    end
  end

  def showOtherShop
    @otherShop = Store.find(params[:id])
    @user = User.find(session[:user_id])
    @check_following = @user.followings.pluck("id").include?(@otherShop.id)
    @getTagAndProduct = @otherShop.getTagAndProduct
    @getScoreShop = @otherShop.getScoreShop



  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(:name, :store_name, :phone, :address_store, :user_id,:avatar)
    end

    def check_has_store
      @user = User.find(session[:user_id])
      if(@user.store)
        return true
      else
        return false
      end
    end

    def set_default_avatar
      if(!@store.avatar.attached?)
        @store.avatar.attach(
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
end
