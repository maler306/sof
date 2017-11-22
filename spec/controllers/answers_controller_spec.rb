require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user)}
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  sign_in_user

  describe 'POST #create' do
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
        expect { post :create, params: { question_id: question, answer:  attributes_for(:invalid_answer), format: :js  } }.to_not change(question.answers, :count)
      end

      it 'renders notice notice' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js  }
        expect(flash[:notice]).to be_present
      end
    end

      it 'redirect to question show view' do
        post :create, params: { question_id: question, answer:  attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
  end

  describe 'GET #edit' do
    context 'edit by author' do
      before { get :edit, xhr: true, params: { question_id: question, id: answer} }
      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update' do
    let!(:author_answer) { create(:answer, question: question, user: @user) }

    context 'update by author with valid attributes' do
      before { process :update, method: :patch, params: { id: author_answer.id, question_id: question, answer: { body: 'new body_10' } } }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq author_answer
      end

      it 'change answer attributes' do
        author_answer.reload
        expect(author_answer.body).to eq 'new body_10'
      end

      it 'redirect to question show view' do
        expect(response).to redirect_to question_path(assigns(:question))
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

  end

  describe 'DELETE #destroy' do

    context 'Author deletes answer' do
      let(:author_answer) { create(:answer, question: question, user: @user) }
      it 'deletes answer' do
        author_answer
        expect { delete :destroy, params: { id: author_answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: author_answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'NotAuthor answer' do
      it 'not deletes answer' do
        answer
        expect { delete :destroy, params: { id: answer, question_id: question } }.not_to change(Answer, :count)
      end
    end
  end

end
