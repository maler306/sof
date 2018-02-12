require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  # describe 'GET #edit' do
  #   sign_in_user
  #   before { get :edit, params: {id: question} }

  #   it 'assigns the requested question to @question' do
  #     expect(assigns(:question)).to eq question
  #   end

  #   it 'render edit view' do
  #     expect(response).to render_template :edit
  #   end
  # end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question:  attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question:  attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question:  attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question:  attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:users_question) { create(:question, user: @user) }

    context 'update by author with valid attributes' do
      before { process :update, method: :patch, params: {id: users_question.id, question:  { title: 'new title', body: 'new body' } }, format: :js }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq users_question
      end

      it 'change question attributes' do
        users_question.reload
        expect(users_question.title).to eq 'new title'
        expect(users_question.body).to eq 'new body'
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'update by author with invalid attributes' do
      before { patch :update, params: { id: users_question.id, question:  { title: 'new title', body: nil} }, format: :js }

      it 'does not change question attributes' do
        users_question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'As non-author of question' do
      let!(:foreign_question) { create(:question) }
      let(:update_foreign_question) { post :update, params: { id: foreign_question.id, question: { title: 'edited title', body: 'edited body' }, format: :js } }

      it 'does not update foreign question' do
        expect { update_foreign_question}.to_not change { foreign_question.reload.title }
        expect { update_foreign_question}.to_not change { foreign_question.reload.body }
        expect { update_foreign_question }.to_not change { foreign_question.reload.updated_at }
      end
    end

  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'delete by author' do
      let!(:users_question) { create(:question, user: @user) }

      it 'deletes question' do
        users_question
        expect { delete :destroy, params: { id: users_question.id } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: users_question.id }
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete by not author' do

      it 'deletes question' do
        question
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end

  end
  end

end
