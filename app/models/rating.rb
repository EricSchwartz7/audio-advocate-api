class Rating < ApplicationRecord
  has_many :type_ratings
  has_many :types, through: :type_ratings
  belongs_to :review
end
