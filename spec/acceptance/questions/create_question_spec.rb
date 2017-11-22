require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the question' do

    sign_in(user)

    visit '/questions'
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'Authenticated user try to create the question with invalid data' do

    sign_in(user)

    visit '/questions'
    click_on 'Ask question'
    fill_in 'Title', with: 'Te'
    fill_in 'Text', with: 'te'
    click_on 'Create'

    expect(page).to have_content 'Title is too short (minimum is 5 characters)'
    expect(page).to have_content 'Body is too short (minimum is 5 characters)'
    expect(page).to have_field('Title', :with => 'Te')
    expect(page).to have_field('Text', :with => 'te')
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
