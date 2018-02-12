require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user)}
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:other_question) { create(:question) }
  let(:other_question_answer) { create(:answer, question: other_question) }
  sign_in_user

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(@user.answers, :count).by(1)
      end

      it 'renders success notice' do
        post :create, params: { question_id: question, answer:  attributes_for(:answer), format: :js }
        expect(flash[:notice]).to be_present
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer:  attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer:  attributes_for(:invalid_answer), format: :js  } }.to_not change(Answer, :count)
      end

      it 'renders notice notice' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js  }
        expect(flash[:notice]).to be_present
      end
    end

      it 'render create template' do
        post :create, params: { question_id: question, answer:  attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
  end

  describe 'PATCH #update' do
    let!(:author_answer) { create(:answer, question: question, user: @user) }

    context 'update by author with valid attributes' do
      before { process :update, method: :patch, params: { id: author_answer.id, question_id: question, answer: { body: 'new body_10' } }, format: :js }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq author_answer
      end

      it ' assigns the question' do
        expect(assigns(:question)).to eq question
      end

      it 'change answer attributes' do
        author_answer.reload
        expect(author_answer.body).to eq 'new body_10'
      end

      it 'render update template' do
        expect(response).to render_template :update
      end

    end

    context 'update by author with invalid attributes' do
      before { patch :update, params: { id: author_answer, question_id: question, answer: { body: nil } }, format: :js  }

      it 'does not change answer attributes' do
        author_answer.reload
        expect(author_answer.body).to match /^MyTextTextText\d+$/
      end

      it 're-render question view' do
        expect(response).to render_template :update
      end
    end

    context 'As non-author of answer' do
      let!(:foreign_answer) { create(:answer) }
      let(:update_foreign_answer) { post :update, params: { question_id: foreign_answer.question.id, id: foreign_answer.id, answer: { body: 'edited body' }, format: :js } }

      it 'does not update foreign answer' do
        expect { update_foreign_answer }.to_not change { foreign_answer.reload.body }
        expect { update_foreign_answer }.to_not change { foreign_answer.reload.updated_at }
      end
    end

  end

  describe 'DELETE #destroy' do

    context 'Author deletes answer' do
      let(:author_answer) { create(:answer, question: question, user: @user) }
      it 'deletes answer' do
        author_answer
        expect { delete :destroy, params: { id: author_answer, question_id: question }, format: :js }.to change(@user.answers, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'NotAuthor answer' do
      it 'not deletes answer' do
        answer
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.not_to change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(response).to render_template :destroy
      end

    end
  end

  describe 'PATCH#best_answer' do
    let(:foreing_question)  { create(:question) }
    let(:another_answer)   { create(:answer, question: foreing_question) }

    before {question.update(user: @user) }

    context 'question owner' do
      it 'choose answer best' do
        patch :best, params: {  question_id: question, id: answer}, format: :js
        answer.reload
        expect(answer.best).to be true
      end

      it 'render update template' do
        patch :best, params: { question_id: question, id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'question owner choose another best answer' do
    let(:best_answer)  { create(:answer, best: true, question: question) }

      it 'choose another best answer' do
        patch :best, params: {  question_id: question, id: answer}, format: :js
        answer.reload
        expect(answer.best).to be true
      end
    end

    context 'not question owner' do
      it 'Can not choose answer best' do
        patch :best, params: {  question_id: question, id: another_answer}, format: :js
        another_answer.reload
        expect(another_answer.best).to be false
      end
    end

  end

end
