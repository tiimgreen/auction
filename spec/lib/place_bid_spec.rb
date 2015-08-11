require 'spec_helper'
require 'place_bid'

describe PlaceBid do
  let(:selling_user) { FactoryGirl.create(:user) }
  let(:bidding_user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:product) { FactoryGirl.create(:product, user_id: selling_user.id) }
  let(:product_auction) do
    FactoryGirl.create(:product_auction,
      product_id: product.id,
      value: 10,
      ends_at: Time.now + 24.hours
    )
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

  it 'notifies user the auction has ended' do
    service = PlaceBid.new(
      value: 11,
      user_id: bidding_user.id,
      product_auction_id: product_auction.id
    )

    service.execute

    another_service = PlaceBid.new(
      value: 12,
      user_id: bidding_user.id,
      product_auction_id: product_auction.id
    )

    Timecop.travel(Time.now + 25.hours)
    another_service.execute

    expect(product_auction.current_bid).to eq(11)
    expect(another_service.status).to eq(:won)
    expect(another_service.error).to eq('The auction has ended')
  end
end
