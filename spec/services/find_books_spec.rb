require_relative "../rails_helper"

RSpec.describe FindBooks do
  let(:user) {
    User.create!(first_name: 'D', last_name: 'G', email: 'dg@gmail.com', password: 'asdfasdf')
  }

  describe '#call' do
    it 'finds books with query value in the title' do
      service = FindBooks.new('Lion King')

      response = service.call

      expect(response.flatten[0]).to include('Lion King')
    end
  end
end
