require 'rails_helper'

feature 'Question with an answers', %q{
  In order to find out solution of a problem
  As a user
  I want to view question with its answers and form for new answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }


  scenario 'User views the question and answers' do

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_css("table.answers tr", :count=>3+1)#в конце таблицы пустой tr c <td class="body"></td>

    within('.answers') do
      answers.each do |answer|
        expect(page).to have_content answer.body
        expect(answer.body).to match /^MyTextTextText\d+$/
      end
    end

  end

  scenario 'Aunteficate user views the form for answering question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_field('Give your answer')
    expect(page).to have_selector("input[type=submit][value='Add answer']")
  end
end
