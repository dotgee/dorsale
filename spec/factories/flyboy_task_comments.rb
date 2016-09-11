FactoryGirl.define do
  factory :flyboy_task_comment, class: ::Dorsale::Flyboy::TaskComment do
    task { create(:flyboy_task) }
    date { Time.zone.now }
    progress 95
    description "I-am-a-task-comment"
    author { create(:user) }
  end
end
