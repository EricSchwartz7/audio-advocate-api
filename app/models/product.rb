require 'nokogiri'
require 'open-uri'

class Product < ApplicationRecord
  has_many :reviews
  belongs_to :type

  def avg_rating
    if self.reviews != []
      ratings = self.reviews.map { |review| review.rating }
      avg = ratings.reduce { |sum, rating| sum + rating }.to_f / ratings.size
      avg.round(1)
    else
      "No ratings"
    end
  end

end
