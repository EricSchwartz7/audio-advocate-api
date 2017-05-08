class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :category, :alt_category, :other_attribute, :type_id, :img, :price, :avg_rating, :num_ratings

  def avg_rating
    object.avg_rating
  end

  def num_ratings
    object.reviews.length
  end

end
