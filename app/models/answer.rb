class Answer < ApplicationRecord
  validates :body, presence: true, length: { minimum: 10 }
  validates :question_id, presence: true
  belongs_to :question
end
