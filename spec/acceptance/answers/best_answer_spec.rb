require 'acceptance_helper'

feature 'Choose best answer', %q{
  In order to mark the answer, that solved my problem
  As an author of question
  I want to be able to choose the best answer
} do

  given(:user)       { create(:user) }
  given(:author) { create(:user) }
  given!(:question)   { create(:question, user: author) }
  given!(:answers)    { create_list(:answer, 2, question: question, user: author) }

  describe "Not author of question can't choose the best answer" do
    before { visit question_path(question) }

    scenario 'as a unauthenticated user' do
      expect(page).to_not have_link 'chose as the best'
    end

    scenario 'as a authenticated user' do
      sign_in(user)
      expect(page).to_not have_link 'chose as the best'
    end
  end

  describe 'Author of question' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'see the button to choose the best answer' do
      expect(page).to have_button 'chose as the best', count: 2
    end

    scenario 'try to choose the best answer', js: true do
      within "#answer-#{answers.last.id}" do
        click_on 'chose as the best'
      end

      within '.best-answer' do
        expect(page).to have_content answers.last.body
        expect(page).to have_content "The best answer"
        expect(page).to_not have_content answers.first.body
      end
    end

    scenario 'try to choose another best answer, when one already chosen', js: true do
      within "#answer-#{answers.last.id}" do
        click_on 'chose as the best'
      end

      within "#answer-#{answers.first.id}" do
        click_on 'chose as the best'
      end

      within '.best-answer' do
        expect(page).to have_content answers.first.body
        expect(page).to_not have_content answers.last.body
      end
    end
  end

end
