require 'nokogiri'
require 'open-uri'
# require 'pry'

# For later: Use the Amazon Product Advertising API to get Amazon reviews

class Scraper

  @base_url = "https://www.sweetwater.com/store/detail/"

  def self.amazon_rating(url)
    page = Nokogiri::HTML(open(url))
    # binding.pry
    array = []
    array << page.css('.crIFrameNumCustReviews').children.css('img').attr('alt').text
    array << page.css('.crIFrameNumCustReviews').children.css('a')[1].text
  end

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
    array << price.gsub(/[.,]/, '')
    # if the interface has preamps, add that info
    num_preamps = page.css("tr").select{|tr| tr.text.include? "Number of Preamps" }
    if num_preamps.length > 0
      array << num_preamps[0].css("td").text
    else
      array << "N/A"
    end
  end

  def self.make_product(product_name, category)
    # creates and stores the product instance
    array = self.get_sweetwater_product(product_name)
    product = Product.new
    product.name = array[1]
    product.brand = array[0]
    product.img = array[2]
    product.price = array[3]
    product.category = category
    product.alt_category = array[4]
    product.type_id = 3
    product.save
    return product.id
  end

  def self.get_sweetwater_reviews(product_name, product_id)
    doc = Nokogiri::HTML(open(@base_url + product_name + "/reviews"))
    doc.css(".customers .list li").each do |review|
      rev = Review.new
      rev.subject = review.css("h4").text
      rev.content = review.css("p").text
      rev.author = review.css("h5").text
      rev.rating = review.css("[data-rating]")[0].values[0]
      rev.product_id = product_id
      rev.origin = "Sweetwater"
      rev.save
    end
  end

  def self.make_product_and_reviews(product_name, category)
    product_id = self.make_product(product_name, category)
    self.get_sweetwater_reviews(product_name, product_id)
  end

  def self.make_all_products(url, category)
    page = Nokogiri::HTML(open(url))
    product_names = page.css(".product-card").map { |product| product.attr("data-itemid") }
    # product_names.each do |name|
    #   if name
    #     make_product_and_reviews(name)
    #   end
    # end
    i = 0
    while i < 20 do
      if product_names[i]
        make_product_and_reviews(product_names[i], category)
      end
      puts i
      i += 1
    end
  end

  def self.search_gc(keywords)
    base_url = "http://www.guitarcenter.com/search?typeAheadSuggestion=true&typeAheadRedirect=true&Ntt="
    search_terms = keywords.gsub(" ", "+")
    page = Nokogiri::HTML(open(base_url + search_terms))
    if page.css('.product').length > 0
      product_url = page.css('.product a')[0].attr('href')
      puts product_url
      page = Nokogiri::HTML(open("http://guitarcenter.com" + product_url))
    end
    page
  end

  def self.get_gc_reviews(keywords, product_id)
    product_page = search_gc(keywords)
    if product_page.css('.pr-review-wrap').length > 0
      product_page.css('.pr-review-wrap').each do |review|
        rev = Review.new
        rev.subject = review.css(".pr-review-rating-headline").text
        rev.content = review.css(".pr-comments").text
        rev.author = review.css(".pr-review-author-name span").text
        rev.rating = review.css(".pr-rating").text
        # product = Product.where("name LIKE :keywords", keywords: "%#{keywords.split(' ').slice(1..3).join(' ')}%")
        rev.product_id = product_id
        rev.origin = "Guitar Center"
        rev.save
      end
    else
      puts "No reviews"
    end
  end

  def self.get_all_gc_reviews
    Product.all.each do |product|
      name = product.name.split.slice(0..3).join(" ")
      get_gc_reviews(name, product.id)
    end
  end

end
