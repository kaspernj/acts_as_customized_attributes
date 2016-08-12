# frozen_string_literal: true
class Order < ActiveRecord::Base
  acts_as_customized_attributes

  belongs_to :user
end
