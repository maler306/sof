require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user
  I want to be able to delete my questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }


  scenario 'Authenticated user delete the own question' , js: true do

    sign_in(user)
    visit question_path(question)
    page.accept_confirm do
     click_link 'Delete question'
    end

    expect(current_path).to eq(questions_path)
    expect(page).to have_content 'Your question succefully deleted.'
    expect(page).not_to have_content question.title

  end

  scenario 'Non-authenticated user do not see delete question link' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

end
