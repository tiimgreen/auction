class ProductAuctionsController < ApplicationController

  def create
    product = Product.find(params[:product_id])
    auction = product.product_auctions.build(product_auction_params)

    if auction.save
      flash[:success] = 'Product sent to auction'
    else
      flash[:warning] = 'Something went wrong, please review your data.'
    end

    redirect_to product
  end

  private

    def product_auction_params
      params.require(:product_auction).permit(:value)
    end
end
