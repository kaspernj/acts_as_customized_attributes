require "spec_helper"

describe User do
  let!(:user){ create :user }
  let!(:order){ create :order, user: user }

  before do
    user.update_customized_attributes(facebook_email: "kaspernj@facebook.com")
  end

  it "should be possible to set custom data and it shouldn't mix up" do
    user.update_customized_attributes(facebook_email: "kaspernj@facebook.com")

    order.update_customized_attributes(affiliate_data: "test")
    order.customized_attributes[:affiliate_data].should eq "test"
    order.customized_attributes[:facebook_email].should eq nil
  end

  it "should autodelete when destroyed" do
    user_id = user.id
    user.destroy

    UserData.joins(:data_key).where(resource_id: user_id, user_data_keys: {name: "facebook_email"}).first.should eq nil
  end
end
