require 'acceptance_helper'

feature 'Edit answer', %q{
  In order to edit answer for the question
  As an author of answer
  I want to be able to edit my answers
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticate user as author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Sees link for editing his answer' do
      within '.answers' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'Can edit own answer', js: true  do

      within "#answer-#{answer.id}" do
        click_on 'Edit answer'

        expect(page).to have_field('Answer')
        expect(page).to_not have_content 'Edit answer'
        fill_in 'Answer', with: 'Edit_text text text'
        click_on 'Save update'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edit_text text text'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'Edit answer'
      end
    end

    scenario 'Can not edit his own answer with invalid data', js: true  do
      within "#answer-#{answer.id}" do
        click_on 'Edit answer'

        fill_in 'Answer', with: ''
        click_on 'Save update'
      end

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content 'Body is too short (minimum is 10 characters)'
    end

  end

  scenario 'User do not see links for editing not his answer' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_button 'Edit answer'
  end

  scenario 'Non-authenticated user  do not see links for editing answers' do
    visit question_path(question)

    expect(page).to_not have_button 'Edit answer'
  end

end
