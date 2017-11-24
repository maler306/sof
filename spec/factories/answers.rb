FactoryBot.define do

  sequence :body do |n|
    "MyTextTextText#{n}"
  end

  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
    user nil
  end

end
