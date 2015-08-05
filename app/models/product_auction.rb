class ProductAuction < ActiveRecord::Base
  belongs_to :product
  has_many :bids, dependent: :destroy

  validates :product_id, presence: true

  def top_bid
    bids.order(value: :desc).first || NullBid.new
  end

  def current_bid
    top_bid.is_a?(NullBid) ? value : top_bid.value
  end

  def ended?
    ends_at < Time.now
  end

  def won_by(user)
    ended? ? top_bid.user == user : false
  end

  def status(user)
    if won_by(user)
      'You won the auction.'
    elsif any_bids_from?(user)
      'You lost the auction.'
    else
      'Auction has ended.'
    end
  end

  private

  def any_bids_from?(user)
    bids.any? ? bids.map(:user).include?(user) : false
  end
end
