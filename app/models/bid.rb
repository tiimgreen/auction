class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :product_auction

  validates_numericality_of :value
end
