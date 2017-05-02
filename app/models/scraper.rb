require 'nokogiri'
require 'open-uri'
require 'pry'

# For later: Use the Amazon Product Advertising API to get Amazon reviews

class Scraper

  @base_url = "https://www.sweetwater.com/store/detail/"

  def self.get_sweetwater_product(product_name)
    # gets the page and returns an array of [name, brand]
    page = Nokogiri::HTML(open(@base_url + product_name))
    page.css(".product__name").text.strip.split("\n\t\t\t")
  end

  def self.make_product(product_name)
    # creates and stores the product instance
    array = self.get_sweetwater_product(product_name)
    product = Product.new
    product.name = array[1]
    product.brand = array[0]
    product.type_id = 3
    product.save
    return product.id
  end

  def self.get_sweetwater_reviews(product_name, product_id)
    doc = Nokogiri::HTML(open(@base_url + product_name + "/reviews"))
    doc.css(".list li").each do |review|
      rev = Review.new
      rev.subject = review.css("h4").text
      rev.content = review.css("p").text
      rev.author = review.css("h5").text
      rev.rating = review.css("[data-rating]")[0].values[0]
      rev.product_id = product_id
      rev.save
    end
  end

  def self.make_product_and_reviews(product_name)
    product_id = self.make_product(product_name)
    self.get_sweetwater_reviews(product_name, product_id)
  end

end
