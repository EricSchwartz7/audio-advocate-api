require 'nokogiri'
require 'open-uri'
require 'pry'

# For later: Use the Amazon Product Advertising API to get Amazon reviews

class Scraper

  @base_url = "https://www.sweetwater.com/store/detail/"

  def self.get_sweetwater_product(product_name)
    # gets the page
    page = Nokogiri::HTML(open(@base_url + product_name))
    # returns an array of [name, brand]
    array = page.css(".product__name").text.strip.split("\n\t\t\t")
    # adds the img src to the array
    # array << page.css("img")[2].attr('src')
    array << "https://media.sweetwater.com/images/dynamic/#{product_name}/original-300.jpg"
    # gets price in dollars and cents, then combines them as an integer
    price = page.css(".product-price--final dollars").first.text + page.css(".product-price--final cents").first.text
    array << price.gsub('.', '')
  end

  def self.make_product(product_name)
    # creates and stores the product instance
    array = self.get_sweetwater_product(product_name)
    product = Product.new
    product.name = array[1]
    product.brand = array[0]
    product.img = array[2]
    product.price = array[3]
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

  def self.make_all_products(url)
    page = Nokogiri::HTML(open(url))
    product_names = page.css(".product-card").map { |product| product.attr("data-itemid") }
    # product_names.each do |name|
    #   if name
    #     make_product_and_reviews(name)
    #   end
    # end
    i = 0
    while i < 10 do
      if product_names[i]
        make_product_and_reviews(product_names[i])
      end
      i += 1
    end
  end

end
