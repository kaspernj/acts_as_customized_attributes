# frozen_string_literal: true
require "spec_helper"

describe User do
  let!(:user) { create :user }
  let!(:order) { create :order, user: user }

  before do
    UserDataKey.update_cache_name_to_id

    user.update_customized_attributes(facebook_email: "kaspernj@facebook.com")
    expect(user.customized_attribute(:facebook_email)).to eq "kaspernj@facebook.com"
  end

  it "should be possible to set custom data and it shouldn't mix up" do
    order.update_customized_attributes(affiliate_data: "test")
    expect(order.customized_attributes[:affiliate_data]).to eq "test"
    expect(order.customized_attributes[:facebook_email]).to eq nil
  end

  it "should autodelete when destroyed" do
    user_id = user.id
    user.destroy

    expect(UserData.joins(:data_key).where(resource_id: user_id, user_data_keys: {name: "facebook_email"}).first).to eq nil
  end

  it "should help search for attributes" do
    users_query = User.where_customized_attribute(:facebook_email, "kaspernj@facebook.com")
    expect(users_query.count).to eq 1
    expect(users_query.first).to eq user
  end

  it "should clear cache when key is destroyed" do
    keys = UserDataKey.where(name: "facebook_email")
    expect(keys.count).to eq 1
    keys.destroy_all
    expect(keys.count).to eq 0

    expect do
      UserDataKey.id_for_name("facebook_email")
    end.to raise_error(KeyError)
  end

  it "should update the cache name" do
    key = UserDataKey.where(name: "facebook_email").first
    key.name = "facebook_mail"
    key.save!

    expect do
      UserDataKey.id_for_name("facebook_email")
    end.to raise_error(KeyError)

    expect(user.customized_attribute(:facebook_mail)).to eq "kaspernj@facebook.com"
  end

  it "shouldn't allow the same key twice" do
    expect(user.customized_attribute(:facebook_email)).to eq "kaspernj@facebook.com"

    expect do
      UserDataKey.create!(name: "facebook_email")
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "shouldn't allow the same data twice" do
    expect do
      UserData.create!(
        resource_id: user.id,
        data_key_id: UserDataKey.id_for_name("facebook_email"),
        value: "test"
      )
    end.to raise_error(ActiveRecord::RecordNotUnique)
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

    expect(user.customized_attribute(:facebook_email)).to eq "test@example.com"
    expect(user.customized_attribute(:some_attribute)).to eq "test"
  end
end
