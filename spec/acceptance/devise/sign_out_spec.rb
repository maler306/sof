require 'acceptance_helper'

feature 'User sign out',  %q{
  In order to be able to ask question
  As an user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)

    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

scenario 'Non-registered user does not see note Log out' do
  visit root_path

  expect(page).to have_no_content 'Log out'
  expect(page).to have_content 'Log In'
end

end
