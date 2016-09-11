require "rails_helper"

describe Dorsale::Alexandrie::AttachmentsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:uploaded_file){
    path = Rails.root.join("../../spec/files/pdf.pdf").to_s
    Rack::Test::UploadedFile.new(path, "application/pdf")
  }

  let(:valid_attributes){
    attachable = DummyModel.create!(name: "A")

    {
      :attachable_id   => attachable.id,
      :attachable_type => attachable.class.to_s,
      :file            => uploaded_file,
    }
  }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe "create" do
    it "should create attachment" do
      post :create, params: {attachment: valid_attributes, back_url: "/"}
      expect(assigns(:attachment)).to be_persisted
    end

    it "should redirect to back_url" do
      post :create, params: {attachment: valid_attributes, back_url: "/"}
      expect(response).to redirect_to("/")
    end
  end

  describe "destroy" do
    it "should delete attachment" do
      attachment = create(:alexandrie_attachment)
      expect {
        delete :destroy, params: {id: attachment, back_url: "/"}
      }.to change(::Dorsale::Alexandrie::Attachment, :count).by(-1)
    end

    it "should redirect to back_url" do
      attachment = create(:alexandrie_attachment)
      delete :destroy, params: {id: attachment, back_url: "/"}
      expect(response).to redirect_to("/")
    end
  end
end
