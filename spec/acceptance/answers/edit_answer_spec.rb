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

  scenario 'User as author can edit own answer', js: true  do

    sign_in(user)
    visit question_path(question)
    click_on 'Edit answer'

    fill_in 'Edit your answer:', with: 'Edit_text text text'
    click_on 'Update answer'

    expect(page).to have_content 'Your answer successfully edited.'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Edit_text text text'
  end

  scenario 'User as author can not edit his own answer with invalid data', js: true  do

    sign_in(user)
    visit question_path(question)
    click_on 'Edit answer'

    fill_in 'Edit your answer:', with: ''
    click_on 'Update answer'

    expect(current_path).to eq edit_question_answer_path(question, answer)
    expect(page).to have_content 'Your answer not updated'
    expect(page).to have_content 'Body is too short (minimum is 10 characters)'
  end

  scenario 'User do not see links for editing not his answer' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_button 'Edit answer'
  end

  scenario 'Non-authenticated user  do not see links for editing not his answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Edit answer'
  end

end
