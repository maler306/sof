require 'rails_helper'

feature 'Edit answer', %q{
  In order to edit answer for the question
  As an authenticated user
  I want to be able to edit my answers
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User as author can edit own answer' do

    sign_in(user)
    visit question_path(question)
    click_on 'Edit answer'

    fill_in 'Edit your answer:', with: 'Edit_text text text'
    click_on 'Update answer'

    expect(page).to have_content 'Your answer successfully edited.'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Edit_text text text'

  end

  scenario 'User do not see link for editing or delete not his answer' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_button 'Edit answer'
    expect(page).to_not have_button 'Delete answer'
  end


end
