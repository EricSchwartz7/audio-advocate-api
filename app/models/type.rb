class Type < ApplicationRecord
  has_many :type_ratings
  has_many :ratings, through: :type_ratings
  has_many :products
end
