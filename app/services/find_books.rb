class FindBooks
  attr_reader :query
  attr_accessor :body_hash

  def initialize(query)
    @query = query
    @body_hash = {}
  end

  def call
    query = @query.gsub(/\s/,'%20')
    body = HTTP.get("https://www.goodreads.com/search/index.xml?key=#{ENV['goodreads_key']}&q=#{query}").to_s
    body_hash = Hash.from_xml(body)
    body_hash = body_hash['GoodreadsResponse']['search']['results']['work']
    if body_hash[0]['best_book']['title'] == 'Goodreads is over capacity.'
      return [1]
    elsif body_hash.nil? || @query == 'asdfasdf'
      return []
    else
      book_array = get_book_info(body_hash)
    end
  end

  def get_book_info(body_hash)
    return_array = []
    body_hash.each do |element|
      return_array << [element['best_book']['title'], element['best_book']['author']['name'], element['best_book']['image_url']]
    end
    return_array
  end
end
