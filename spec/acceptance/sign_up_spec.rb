require 'rails_helper'

feature 'User sign up',  %q{
  In order to be able to ask question
  As an non-registred user
  I want to be able to sign up
} do

  given(:other_user) { create(:user) }

  scenario 'Non-registered user try to sign up' do
    data = attributes_for(:user)

    visit root_path
    click_on 'SignUp'

    fill_in 'Email', with: data[:email]
    fill_in 'Password', with: data[:password]
    fill_in 'Password confirmation', with: data[:password_confirmation]
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
    expect(page).to have_link('Log out', href: destroy_user_session_path)
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign up with non-valid attributes' do

    visit new_user_registration_path
    fill_in 'Email', with: other_user[:email]
    fill_in 'Password', with: '12345'
    fill_in 'Password confirmation', with: nil
    click_on 'Sign up'

    expect(page).to have_content  "Email has already been taken"
    expect(page).to have_content  "Password is too short (minimum is 6 characters)"
    expect(page).to have_content  "Password confirmation doesn't match Password"
    expect(current_path).to eq user_registration_path
  end

end
