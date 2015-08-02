require 'place_bid'

class BidsController < ApplicationController
  def create
    service = PlaceBid.new(bid_params)

    if service.execute
      flash[:success] = 'Bid successfully placed'
    else
      flash[:warning] = service.error
    end

    redirect_to product_path(params[:product_id])
  end

  private

  def bid_params
    params.require(:bid).permit(:value).merge!(
      user_id: current_user.id,
      product_auction_id: params[:product_auction_id]
    )
  end
end
