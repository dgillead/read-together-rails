class FindBooks
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def call
    body = HTTP.get("https://www.goodreads.com/search/index.xml?key=#{Rails.application.secrets.goodreads_api_key}=#{query}").to_s
    body_hash = Hash.from_xml(body)
    title = body_hash['GoodreadsResponse']['search']['results']['work'][0]['best_book']['title']
    author = body_hash['GoodreadsResponse']['search']['results']['work'][0]['best_book']['author']['name']
    image = body_hash['GoodreadsResponse']['search']['results']['work'][0]['best_book']['image_url']
    [title, author, image]
  end
end
