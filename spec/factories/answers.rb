FactoryGirl.define do
  # factory :answer do
  #   sequence(:body) { |n| "answer_body_#{n}" }
  #   question

  #   factory :accepted_answer do
  #     accepted true
  #   end
  # end

  # factory :invalid_answer, class: 'Answer' do
  #   body nil
  #   question nil
  # end

  factory :answer do
    body "MyTextText"
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

end
