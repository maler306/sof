require 'rails_helper'

feature 'Question with an answers', %q{
  In order to find out solution of a problem
  As a user
  I want to view question with its answers and form for new answer
} do

  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }


  scenario 'User views the question and answers' do

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    "#{answers.each {|answer| expect(page).to have_content answer.body } }"
    expect(page).to have_field('Give your answer')
    expect(page).to have_selector("input[type=submit][value='Add answer']")
  end


end
