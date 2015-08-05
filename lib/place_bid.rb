class PlaceBid
  attr_accessor :error

  def initialize(options)
    @value = options[:value].to_f
    @user_id = options[:user_id]
    @auction_id = options[:product_auction_id]
  end

  def execute
    auction = ProductAuction.find(@auction_id)

    if @value <= auction.current_bid
      @error = 'That bid is below the current bid'
      return false
    end

    auction.bids.create(value: @value, user_id: @user_id)
  end
end
