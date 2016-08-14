# frozen_string_literal: true
class CreateOrderCustomizedAttributes < ActiveRecord::Migration
  def up
    Order.create_customized_attributes!
  end

  def down
    Order.drop_customized_attributes!
  end
end
