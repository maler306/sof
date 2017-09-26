class Question < ApplicationRecord
  validates :title, :body, presence: true, length: { minimum: 5 }

  has_many :answers, dependent: :destroy
end
