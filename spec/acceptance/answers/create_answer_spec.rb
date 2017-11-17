require 'rails_helper'

feature 'Create answer', %q{
  In order to give answer for question
  As an authenticated user
  I want to be able to give an answer to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create the answer for the question' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Give your answer', with: 'New answer for the question.'
    click_on 'Add answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer created'#не работает c: flash[:success] = 'Your answer created'
    expect(page).to have_content 'New answer for the question.'
  end

  scenario 'Non-authenticated user  do not see form for answering question' do
    visit question_path(question)

    expect(page).not_to have_field('Give your answer')
    expect(page).not_to have_selector("input[type=submit][value='Add answer']")
  end

  scenario 'user try to create non valid answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Give your answer', with: 'New.'
    click_on 'Add answer'

    expect(page).to have_content 'Your answer not created'
  end

end