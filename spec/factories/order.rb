# frozen_string_literal: true
FactoryGirl.define do
  factory :order do
    association :user, factory: :user
  end
end
