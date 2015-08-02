require 'spec_helper'
require 'place_bid'

describe PlaceBid do
  let(:selling_user) { FactoryGirl.create(:user) }
  let(:bidding_user) { FactoryGirl.create(:user) }
  let(:product) { FactoryGirl.create(:product, user_id: selling_user.id) }
  let(:product_auction) do
    FactoryGirl.create(:product_auction, product_id: product.id, value: 10)
  end

  it 'places a bid' do
    new_bid_value = 11
    service = PlaceBid.new(
      value: new_bid_value,
      user_id: bidding_user.id,
      product_auction_id: product_auction.id
    )
    service.execute

    expect(product_auction.current_bid).to eq(new_bid_value)
  end

  it 'fails to place a bid that is under the current value' do
    service = PlaceBid.new(
      value: 9,
      user_id: bidding_user.id,
      product_auction_id: product_auction.id
    )
    service.execute

    expect(product_auction.current_bid).to eq(10)
    expect(service.error).to eq('That bid is below the current bid')
  end
end
