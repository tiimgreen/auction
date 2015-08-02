class ProductAuction < ActiveRecord::Base
  belongs_to :product
  has_many :bids

  validates :product_id, presence: true

  def current_bid
    top_bid.nil? ? value : top_bid.value
  end

  private

  def top_bid
    bids.order(value: :desc).first
  end
end
