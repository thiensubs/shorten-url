# frozen_string_literal: true

FactoryBot.define do
  factory :my_link do
    sequence(:a_url) { |n| "https://youtu.be/ioNng23DkIM#{n}" }
    user factory: :user
  end
end
