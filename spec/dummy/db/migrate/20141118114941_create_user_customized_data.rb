class CreateUserCustomizedData < ActiveRecord::Migration
  def up
    User.create_customized_data!
  end

  def down
    User.drop_customized_data!
  end
end
