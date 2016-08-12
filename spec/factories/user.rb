# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email { Forgery::Internet.email_address }
  end
end
