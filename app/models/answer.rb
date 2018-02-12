class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true, length: { minimum: 10 }

  default_scope { order(best: :desc) }

  def accept_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
