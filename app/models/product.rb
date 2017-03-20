class Product < ApplicationRecord
  has_many :reviews
  belongs_to :type
end
