# frozen_string_literal: true
class CreateUserCustomizedAttributes < ActiveRecord::Migration
  def up
    User.create_customized_attributes!
  end

  def down
    User.drop_customized_attributes!
  end
end
