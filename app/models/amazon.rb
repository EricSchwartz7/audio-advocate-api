require 'vacuum'

class Amazon

  def self.search
    request = Vacuum.new

    request.configure(
      aws_access_key_id: 'AKIAJBKJYAGIZMSVADCA',
      aws_secret_access_key: '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',
      associate_tag: 'schwartzmusic-20'
    )

    response = request.item_search(
      query: {
        'Keywords' => 'Architecture',
        'SearchIndex' => 'Books'
      }
    )


  puts response.to_h
  binding.pry
  end


end
