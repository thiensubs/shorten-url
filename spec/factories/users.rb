# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email_#{n}@domain_#{n}.com" }
    password { '123456' }
    sequence(:full_name) { |n| "full_name_#{n}" }
  end
end
