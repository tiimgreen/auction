class Product < ActiveRecord::Base
  belongs_to :user
  has_one :product_auction

  validates :name,    presence: true
  validates :image,   presence: true
  validates :user_id, presence: true
end
