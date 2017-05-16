module Api::V1
  class ProductsController < ApplicationController

    def index
      products = Product.all
      render json: products
    end

    def avg_ratings
      ratings = Product.all.map do |product|
        {(product.avg_rating) => (product.reviews.length)}
      end
      render json: ratings
    end

    def show
      product = Product.find(params[:id])
      render json: product
    end

    def reviews
      reviews = Product.find(params[:id]).reviews
      if reviews.length == 0
        rev = Review.new
        rev.subject = "This product has not yet been reviewed."
        reviews = [rev]
      end
      render json: reviews
    end

    def sort_price
      products = Product.order(:price)
      render json: products
    end

    def sort_price_high
      products = Product.order(price: :desc)
      render json: products
    end

    def sort_rating
      products = Product.all.sort_by do |product|
        [product.avg_rating.is_a?(Float) ? product.avg_rating : 0,
          product.reviews.length]
      end
      render json: products.reverse
    end

    def sort_num_reviews
      products = Product.all.sort_by do |product|
        product.reviews.length
      end
      render json: products.reverse
    end

    def filter_connection
      products = Product.where(category: params[:connection])
      render json: products
    end

    def amazon
      # binding.pry
      product = Product.find(params[:id])
      name = product.name.split.slice(0..2).join(" ")
      brand = product.brand
      title_url = Amazon.search("#{brand} #{name}")
      render json: title_url
    end

  end
end
