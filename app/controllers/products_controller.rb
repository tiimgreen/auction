class ProductsController < ApplicationController
  before_action :set_product, only: %i(show edit update destroy transfer)
  before_action :authenticate_user!, except: %i(index)

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      flash[:success] = 'Product was successfully created.'
      redirect_to @product
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      flash[:notice] = 'Product was successfully updated.'
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:success] = 'Product was successfully destroyed.'
    redirect_to products_url
  end

  def transfer
    if @product.product_auction.ended?
      @product.transfer_to(@product.product_auction.top_bid.user)
      flash[:success] = 'Successfully transferred product'
    else
      flash[:warning] = 'The auction hasn\'t ended yet.'
    end

    redirect_to @product
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :image)
    end
end
