class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create, :destroy, :update, :edit]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question
      flash[:notice] = 'Your answer created'
    else
      flash[:alert] = 'Your answer not created'
      redirect_back fallback_location: @question
    end
  end

  def edit
  end

  def update

    if @answer.update(answer_params) && current_user.owner?(@answer)
      redirect_to @question
      flash[:notice] = 'Your answer successfully edited.'
    else
      flash[:alert] = 'Your answer not updated'
    end
  end

  def destroy
    if current_user.owner?(@answer)
      @answer.destroy
      redirect_to @question
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:notice] = 'Your are not author of the answer'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
