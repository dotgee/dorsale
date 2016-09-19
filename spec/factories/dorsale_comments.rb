FactoryGirl.define do
  factory :dorsale_comment, class: ::Dorsale::Comment do
    commentable { DummyModel.create!(name: "abc") }
    author      { create(:user)                   }
    text        { Faker::Lorem.paragraph          }
  end
end
