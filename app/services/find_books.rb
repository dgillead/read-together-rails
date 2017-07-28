class FindBooks
  attr_reader :query
  attr_accessor :body_hash

  def initialize(query)
    @query = query
    @body_hash = {}
  end

  def call
    query = @query[:query].gsub!(/\s/,'%20')
    body = HTTP.get("https://www.goodreads.com/search/index.xml?key=#{Rails.application.secrets.goodreads_api_key}&q=#{query}").to_s
    body_hash = Hash.from_xml(body)
    body_hash = body_hash['GoodreadsResponse']['search']['results']['work']
    book_array = get_book_info(body_hash)
  end

  def get_book_info(body_hash)
    return_array = []
    body_hash.each do |element|
      return_array << [element['best_book']['title'], element['best_book']['author']['name'], element['best_book']['image_url']]
    end
    return_array
  end
end
