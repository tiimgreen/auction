class Product < ActiveRecord::Base
  belongs_to :user
  has_one :product_auction, dependent: :destroy

  validates :name,    presence: true, length: { maximum: 250 }
  validates :image,   presence: true
  validates :user_id, presence: true

  def owned_by?(logged_in_user)
    user == logged_in_user
  end

  def auction
    product_auction
  end

  def has_auction?
    product_auction.present?
  end

  def transfer_to(user)
    update_attribute(:user_id, user.id)
  end

  def to_claim(user)
    product_auction.won_by(user) &&
      unclaimed_by(user)
  end

  private

  def unclaimed_by(user)
    user_id != user.id
  end
end
