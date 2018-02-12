require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10).on(:create) }

    describe '#choose_best' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer)   { create(:answer, question: question, user: user) }

    it 'change attribute best to true' do
      answer.accept_best
      expect(answer.best).to be true
    end
  end

end
