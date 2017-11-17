require 'rails_helper'

feature 'Edit question', %q{
  In order to edit question
  As an authenticated user
  I want to be able to edit my questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Authenticated user edit the question' do

    sign_in(user)
    visit question_path(question)


    fill_in 'Update question title', with: 'Edited question'
    fill_in 'Update question body', with: 'Edit_text text text'
    click_on 'Update question'

    expect(page).to have_content 'Your question successfully edited.'

  end

  scenario 'Non-authenticated user do not see edit form and edit question button' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_content 'Update question.'
    expect(page).to_not have_field('Update question title', :with => question.title)
    expect(page).to_not have_field('Update question body', :with => question.body)
    expect(page).to_not have_button 'Update question'
  end

end
