class PlaceBid
  def initialize(options)
    @value = options[:value]
    @user_id = options[:user_id]
    @auction_id = options[:product_auction_id]
  end

  def execute
    auction = ProductAuction.find(@auction_id)
    bid = auction.bids.build(value: @value, user_id: @user_id)

    return true if bid.save
  end
end
