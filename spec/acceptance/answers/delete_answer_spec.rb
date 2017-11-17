require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete answer for the question
  As an authenticated user
  I want to be able to delete my answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User as author can delete own answer' , js: true do

    sign_in(user)
    visit question_path(question)
    page.accept_confirm do
     click_link 'Delete answer'
    end

    expect(page).to have_content 'Your answer successfully deleted.'
    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content answer.body
  end

end
