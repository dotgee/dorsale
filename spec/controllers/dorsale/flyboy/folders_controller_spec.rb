require "rails_helper"

describe Dorsale::Flyboy::FoldersController, type: :controller do
  routes { Dorsale::Engine.routes }
  render_views

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  let(:folder){
    create(:flyboy_folder)
  }

  describe '#index' do
    context 'when applying filter' do
      before(:each) do
        Dorsale::Flyboy::Folder.destroy_all
        @folder1 = create(:flyboy_folder, status: "open")
        @folder2 = create(:flyboy_folder, status: "closed")
      end

      it 'should display both when not filtered' do
        get :index
        expect(assigns(:folders)).to eq [@folder2, @folder1]
      end

      it 'should filter by status closed' do
        Dorsale::Flyboy::SmallData::FilterForFolders.new(request.cookies)
          .store(fb_status: "closed")

        get :index
        expect(assigns(:folders)).to eq [@folder2]
      end

      it 'should filter by status open' do
        Dorsale::Flyboy::SmallData::FilterForFolders.new(request.cookies)
          .store(fb_status: "open")

        get :index
        expect(assigns(:folders)).to eq [@folder1]
      end
    end

    context "when sorting" do
      before do
        Dorsale::Flyboy::Folder.destroy_all
        @folder1 = create(:flyboy_folder, name: "Abc", progress: 100, status: "open")
        @folder2 = create(:flyboy_folder, name: "dEF", progress: 0,   status: "closed")
        @folder3 = create(:flyboy_folder, name: "xyz", progress: 35,  status: "closed")
      end

      it "sorting by name asc" do
        get :index, params: {sort: "name"}
        expect(assigns(:folders).to_a).to eq [@folder1, @folder2, @folder3]
      end

      it "sorting by name desc" do
        get :index, params: {sort: "-name"}
        expect(assigns(:folders).to_a).to eq [@folder3, @folder2, @folder1]
      end

      it "sorting by progress asc" do
        get :index, params: {sort: "progress"}
        expect(assigns(:folders).to_a).to eq [@folder2, @folder3, @folder1]
      end

      it "sorting by progress desc" do
        get :index, params: {sort: "-progress"}
        expect(assigns(:folders).to_a).to eq [@folder1, @folder3, @folder2]
      end

      it "sorting by status asc" do
        get :index, params: {sort: "status"}
        expect(assigns(:folders).to_a).to eq [@folder2, @folder3, @folder1]
      end

      it "sorting by status desc" do
        get :index, params: {sort: "-status"}
        expect(assigns(:folders).to_a).to eq [@folder1, @folder2, @folder3]
      end
    end
  end

  describe "#close" do
    before(:each) do
      @folder = create(:flyboy_folder, status: "open")
    end

    it "should close folder" do
      patch :close, params: {id: @folder}
      expect(@folder.reload.status).to eq "closed"
    end

    it "should redirect to folders path" do
      patch :close, params: {id: @folder}
      expect(response).to redirect_to flyboy_folders_path
    end
  end

  describe "#open" do
    before(:each) do
      @folder = create(:flyboy_folder, status: "closed")
    end

    it "should open folder" do
      patch :open, params: {id: @folder}
      expect(@folder.reload.status).to eq "open"
    end

    it "should redirect to folder path" do
      patch :open, params: {id: @folder}
      expect(response).to redirect_to flyboy_folder_path(@folder)
    end
  end

end
