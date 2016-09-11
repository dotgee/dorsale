require "rails_helper"

RSpec.describe User, type: :model do

  it "should have a valid factores" do
    expect(create(:user)).to be_valid
  end

  it { is_expected.to respond_to :is_active }

  describe "default values" do
    it "default active value should be true" do
      @user = create(:user)
      expect(@user.is_active).to eq true
    end

    it 'should create a valid password upon creation' do
      user = create(:user, password: nil, password_confirmation: nil)
      expect(user).to be_persisted
    end

    it 'should not override choosen password' do
      user = create(:user, password: "totototo", password_confirmation: nil)
      expect(user.password).to eq "totototo"
    end

    it 'should send a welcome message upon creation' do
      expect {
        create(:user)
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe "avatar" do
    before do
      @user = create(:user,
        :email  => "user@example.org",
        :avatar => Dorsale::Engine.root.join("spec/files/avatar.png").open,
      )
    end

    it "gravatar_url" do
      expect(@user.gravatar_url).to include "gravatar"
    end

    it "local_avatar_url" do
      expect(@user.local_avatar_url).to include "avatar.png"
    end

    it "avatar_url should return local_avatar_url if present" do
      expect(@user.avatar_url).to include "avatar.png"
    end
    it "avatar_url should return gravatar_url if no local avatar" do
      @user.remove_avatar!
      @user.save!
      expect(@user.avatar_url).to include "gravatar"
    end
  end

end
