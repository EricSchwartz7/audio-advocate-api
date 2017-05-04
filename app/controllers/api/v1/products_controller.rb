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

    # def sort_rating
    #   ratings = Product.all.map do |product|
    #     {(product.avg_rating) => [product.id, product.reviews.length]}
    #   end
    #   products = Product.order()
    #   render json: products
    # end

  end
end
