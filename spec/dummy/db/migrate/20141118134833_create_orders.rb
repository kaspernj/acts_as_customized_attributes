# frozen_string_literal: true
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.float :amount_full
      t.timestamps
    end
  end
end
