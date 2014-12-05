require "spec_helper"

describe User do
  let!(:user){ create :user }
  let!(:order){ create :order, user: user }

  before do
    UserDataKey.update_cache_name_to_id

    user.update_customized_attributes(facebook_email: "kaspernj@facebook.com")
    user.customized_attribute(:facebook_email).should eq "kaspernj@facebook.com"
  end

  it "should be possible to set custom data and it shouldn't mix up" do
    order.update_customized_attributes(affiliate_data: "test")
    order.customized_attributes[:affiliate_data].should eq "test"
    order.customized_attributes[:facebook_email].should eq nil
  end

  it "should autodelete when destroyed" do
    user_id = user.id
    user.destroy

    UserData.joins(:data_key).where(resource_id: user_id, user_data_keys: {name: "facebook_email"}).first.should eq nil
  end

  it "should help search for attributes" do
    users_query = User.where_customized_attribute(:facebook_email, "kaspernj@facebook.com")
    users_query.count.should eq 1
    users_query.first.should eq user
  end

  it "should clear cache when key is destroyed" do
    keys = UserDataKey.where(name: "facebook_email")
    keys.count.should eq 1
    keys.destroy_all
    keys.count.should eq 0

    expect {
      UserDataKey.id_for_name("facebook_email")
    }.to raise_error(KeyError)
  end

  it "should update the cache name" do
    key = UserDataKey.where(name: "facebook_email").first
    key.name = "facebook_mail"
    key.save!

    expect {
      UserDataKey.id_for_name("facebook_email")
    }.to raise_error(KeyError)

    user.customized_attribute(:facebook_mail).should eq "kaspernj@facebook.com"
  end

  it "shouldn't allow the same key twice" do
    user.customized_attribute(:facebook_email).should eq "kaspernj@facebook.com"

    expect {
      UserDataKey.create!(name: "facebook_email")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "shouldn't allow the same data twice" do
    expect {
      UserData.create!(
        resource_id: user.id,
        data_key_id: UserDataKey.id_for_name("facebook_email"),
        value: "test"
      )
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should support transactioner" do
    require "active-record-transactioner"

    ActiveRecordTransactioner.new do |trans|
      user.update_customized_attributes_with_args(
        data: {
          facebook_email: "test@example.com",
          some_attribute: "test"
        },
        transactioner: trans
      )
    end

    user.customized_attribute(:facebook_email).should eq "test@example.com"
    user.customized_attribute(:some_attribute).should eq "test"
  end
end
