require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'owner' do
    let(:user_owner) { create(:user) }
    let(:question) { create(:question, user: user_owner) }
    let(:another_user) { create(:user) }

    it 'user is owner of question' do
      expect(user_owner).to be_owner(question)
    end

    it 'user is not owner' do
      expect(another_user).not_to be_owner(question)
    end
  end

end
