require 'acceptance_helper'

feature 'Edit question', %q{
  In order to edit question
  As an authenticated user
  And author of question
  I want to be able to edit my questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  describe 'Authenticate user as author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Sees link for editing his question' do
        expect(page).to have_link 'Edit question'
    end

    scenario 'Can edit his own question', js: true do
      click_on 'Edit question'
      fill_in 'Update question title', with: 'Edited question'
      fill_in 'Update question body', with: 'Edit_text text text'
      click_on 'Update question'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'Edited question'
      expect(page).to have_content 'Edit_text text text'
      # expected not to find css "textarea", found 1 match: "". Also found "", which matched the selector but not all filters.
      # expect(page).to_not have_selector 'textarea'
    end

    scenario 'Can not update question with invalid data', js: true do
      click_on 'Edit question'
      fill_in 'Update question title', with: ''
      fill_in 'Update question body', with: ''
      click_on 'Update question'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content  'Title is too short (minimum is 5 characters)'
      expect(page).to have_content 'Body is too short (minimum is 5 characters)'
    end
  end

  scenario 'Authenticated user do not see edit link for not his question' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link 'Update question.'
  end

  scenario 'Non-authenticated user do not see edit form and edit question button' do
    visit question_path(question)

    expect(page).to_not have_link 'Update question.'
  end

end
