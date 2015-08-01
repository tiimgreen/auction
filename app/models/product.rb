class Product < ActiveRecord::Base
  belongs_to :user

  validates :name,    presence: true
  validates :image,   presence: true
  validates :user_id, presence: true
end
