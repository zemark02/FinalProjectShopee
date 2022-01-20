class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit destroy ]
  after_action :set_default_img_product , only: %i[create]
  before_action :logged_in_for_buy ,except: %i[]



  def logged_in_for_buy
    if(session[:user_id] == nil)
      redirect_to "/login" ,notice:"Please login"
    end
  end
  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    if @product.save

      tag = params[:product][:tags]
      check = false

      if(["Food", "Electronic", "Vehicle", "Fashion", "Health & Beauty", "Voucher", "other"].include? tag )
        t = Tag.create(tagname:tag)
        HasTag.create(tag_id:t.id,product_id:@product.id)
      else
        t = Tag.create(tagname:"other")
        HasTag.create(tag_id:t.id,product_id:@product.id)
      end

    end
      redirect_to request.referrer
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    @product = Product.find(params.require(:product)[:id])
    respond_to do |format|
      if @product.update(product_params)
        @product.tags.destroy_all
        @product.match_tags.destroy_all
        tag = params[:product][:tags]
        check = false

        if(["Food", "Electronic", "Vehicle", "Fashion", "Health & Beauty", "Voucher", "other"].include? tag )
          t = Tag.create(tagname:tag)
          HasTag.create(tag_id:t.id,product_id:@product.id)
        else
          t = Tag.create(tagname:"other")
          HasTag.create(tag_id:t.id,product_id:@product.id)
        end
        format.html { redirect_to request.referrer}

      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def showProduct
    @product = Product.find(params[:id])
    @user = User.find(session[:user_id])
    @store = @product.store
    @following = Follow.find_by(followee_id:@user.id,following_id:@store.id)
    @order_line_items = @product.order_line_items

    @score = @product.getScoreProduct
    @sold = OrderLineItem.where(product_id:@product.id).count
    @numComment = @product.getNumComment
    @rateStore = @store.getScoreShop
    puts "---score = --------------------------#{@score}-------------------------------------------------"
    puts "---rateShop = ------------------------#{@rateStore}----------------------------------------------"

  end

  def search
    @product = Product.search(params[:name])
    @title = "Search By #{params[:name]}"
  end

  def rate
    rate = params[:rating1]
    comment = params[:comment]
    product_id = params[:product_id]
    order_line_item_id = params[:order_line_item_id]
    Rate.create(comment:comment,rate_score:rate,order_line_item_id:order_line_item_id,user_id:session[:user_id])


    redirect_to request.referrer



  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :description, :quantity, :store_id,img_products: [])
    end




    def set_default_img_product
      if(!@product.img_products.attached?)
        @product.img_products                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      .attach(
          io: File.open(
            Rails.root.join(
              'app','assets','images' ,'no-image-available_1.png'
            )
          ),
          filename: 'no-image-available_1.png',
          content_type: 'image/png'
        )
        end
    end

end
