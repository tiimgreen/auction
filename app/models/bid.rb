class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :product_auction

  validates_numericality_of :value

  def bid_placed_by?(current_user)
    user == current_user
  end
end
