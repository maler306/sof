require 'rails_helper'

feature 'List of questions', %q{
  In order to find interesting content
  As a user
  I want to view questions list
} do

  scenario 'User views the list of questions' do
    questions = FactoryBot.create_list(:question, 3)

    visit '/questions'
    expect(page).to have_content('MyString', count: 3)
    expect(page).to have_link('MyString', href: question_path(questions.first))
    expect(page).to have_link('Ask question', href: new_question_path)
  end

  scenario 'User views the empty list of questions' do
    visit '/questions'
    expect(page).to have_content('No questions found.  Please add some question. Thank you!')
    expect(page).to have_link('Ask question', href: new_question_path)
  end


end
