require 'vacuum'

class Amazon

  def self.search(keywords)
    request = Vacuum.new

    request.configure(
      aws_access_key_id: 'AKIAJBKJYAGIZMSVADCA',
      aws_secret_access_key: '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',
      associate_tag: 'schwartzmusic-20'
    )

    response = request.item_search(
      query: {
        'Keywords' => keywords,
        'SearchIndex' => 'MusicalInstruments',
        'ResponseGroup' => 'ItemAttributes,Reviews'
      }
    )

    # Pluck the URL to the Reviews page
    items = response.parse['ItemSearchResponse']['Items']
    if items["TotalResults"] == "0"
      ["Not found on Amazon"]
    elsif items["TotalResults"] == "1"
      url = items['Item']['CustomerReviews']['IFrameURL']
      title = items['Item']['ItemAttributes']['Title']
      [title, url]
    else
      url = items['Item'][0]['CustomerReviews']['IFrameURL']
      title = items['Item'][0]['ItemAttributes']['Title']
      [title, url]
    end
    # puts url
    # Scrape the average rating and number of ratings from the reviews page
    # Scraper.amazon_rating(url)

  end


end
