module Api::V1
  class ProductsController < ApplicationController

    def index
      products = Product.all
      render json: products
    end

    def get_avg_ratings
      ratings = Product.all.map { |product| {product.name => product.avg_rating} }
      render json: ratings
    end

  end
end
