class AnswersController < ApplicationController
  before_action :set_question, only: [:create, :destroy, :update]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.create(answer_params)
    redirect_to question_path(@question)
    if @answer.save
      flash[:success] = 'Your answer created'
    else
      flash[:alert] = 'Your answer not created'
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
      @answer.destroy
      redirect_to @question
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
