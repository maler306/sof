require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user)}
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'renders success notice' do
        post :create, params: { question_id: question, answer:  attributes_for(:answer) }
        expect(flash[:notice]).to be_present
      end

    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer:  attributes_for(:invalid_answer) } }.to_not change(question.answers, :count)
      end

      it 'renders alert notice' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(flash[:alert]).to be_present
      end
    end

      it 'redirect to question show view' do
        post :create, params: { question_id: question, answer:  attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
  end

  describe 'GET #edit' do
    before { get :edit, xhr: true, params: { question_id: question, id: answer} }
    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do

    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer)  }
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body_10' } }
        answer.reload
        expect(answer.body).to eq 'new body_10'
      end

      it 'redirect to question show view' do
        post :create, params: { question_id: question, answer:  attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'redirects to the updated question' do
        patch :update, params: {id: answer, question_id: question, answer:  attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer, question_id: question, answer: { body: nil } } }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyTextText'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes answer' do
      answer
      expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to question show view' do
      delete :destroy, params: { id: answer, question_id: question }
      expect(response).to redirect_to question_path(question)
    end
  end

end
