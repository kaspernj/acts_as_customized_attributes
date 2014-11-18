require "spec_helper"

describe User do
  let!(:user){ create :user }
  let!(:order){ create :order, user: user }

  it "should be possible to set custom data and it shouldn't mix up" do
    user.update_customized_data(facebook_email: "kaspernj@facebook.com")
    user.customized_data[:facebook_email].should eq "kaspernj@facebook.com"

    order.update_customized_data(affiliate_data: "test")
    order.customized_data[:affiliate_data].should eq "test"
    order.customized_data[:facebook_email].should eq nil
  end
end
