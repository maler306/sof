class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create, :destroy, :update, :edit, :best]
  before_action :set_answer, only: [:edit, :update, :destroy, :best]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
      if @answer.save
        flash[:notice] = 'Your answer created'
      else
        flash[:notice] = 'Your answer not created'
      end
  end

  def update
    if current_user.owner?(@answer)
      @answer.update(answer_params)
    else
      flash[:notice] = 'Your are not author of the answer'
    end
  end

  def destroy
    if current_user.owner?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:notice] = 'Your are not author of the answer'
    end
  end

  def best
    @answer.accept_best if current_user.owner?(@answer.question)
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
