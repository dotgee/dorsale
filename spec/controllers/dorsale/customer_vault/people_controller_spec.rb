require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::PeopleController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe "#corporations" do
    render_views

    it "should return corporations only" do
      corporation = create(:customer_vault_corporation)
      individual  = create(:customer_vault_individual)
      get :corporations
      expect(assigns :people).to eq [corporation]
    end
  end # describe "#corporations"

  describe "#individuals" do
    render_views

    it "should return individuals only" do
      corporation = create(:customer_vault_corporation)
      individual  = create(:customer_vault_individual)
      get :individuals
      expect(assigns :people).to eq [individual]
    end
  end # describe "#individuals"

  describe "#list" do
    describe "sorting" do
      it "should sort people by name by default" do
        abc   = create(:customer_vault_corporation, name: 'Abc Corp')
        bob   = create(:customer_vault_individual, last_name: 'Bob')
        alice = create(:customer_vault_individual, last_name: 'Alice')
        zorg  = create(:customer_vault_corporation, name: 'Zorg Corp')

        get :index

        expect(assigns(:people)).to eq([abc, alice, bob, zorg])
      end
    end # describe "sorting"

    describe "filters" do
      it "should filter by person type" do
        individual  = create(:customer_vault_individual)
        corporation = create(:customer_vault_corporation)

        cookies[:filters] = {person_type: "Dorsale::CustomerVault::Individual"}.to_json

        get :index

        expect(assigns(:people)).to eq [individual]
      end
    end # describe "filters"

    describe "search" do
      it "search should ignore filters" do
        corporation1 = create(:customer_vault_corporation, tag_list: "abc", name: "aaa")
        corporation2 = create(:customer_vault_corporation, tag_list: "xyz", name: "bbb")
        @request.cookies["filters"] = {tags: ["abc"]}.to_json
        get :index, params: {q: "bbb"}
        expect(assigns(:people)).to eq [corporation2]
      end
    end # describe "search"
  end # describe "#liwt"

  describe "#activity" do
    before do
      @person = create(:customer_vault_corporation)
      @comment1 = @person.comments.create!(text: "ABC", created_at: Time.zone.now - 3.days, author: user)
      @comment2 = @person.comments.create!(text: "DEF", created_at: Time.zone.now - 2.days, author: user)
      @comment3 = @person.comments.create!(text: "DEF", created_at: Time.zone.now - 9.days, author: user)
    end

    it "should assigns all comments ordered by created_at DESC" do
      get :activity
      expect(assigns(:comments)).to eq [@comment2, @comment1, @comment3]
    end
  end # describe "#activity"

end
