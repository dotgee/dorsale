require 'rails_helper'

describe Dorsale::Flyboy::Folder do
  it { is_expected.to have_many(:tasks).dependent(:destroy) }
  it { is_expected.to belong_to(:folderable) }

  it { should validate_presence_of :name }

  it "should validate the folder when not step is assigned" do
    folder = build(:flyboy_folder)
    expect(folder).to be_valid
  end

  it "should ensure that status has a valid value" do
    folder = build(:flyboy_folder, status: 999)
    expect(folder).to_not be_valid
  end

  it "should increase the version number" do
    folder = create(:flyboy_folder)
    expect(folder.version).to eq 1
    folder.save
    expect(folder.version).to eq 2
    folder.save
    expect(folder.version).to eq 3
  end

  it "should create tracking" do
    Timecop.freeze DateTime.new(2013, 8, 1, 9, 13, 5)

    folder1 = create(:flyboy_folder)
    folder2 = create(:flyboy_folder)
    folder3 = create(:flyboy_folder)

    expect(folder1.tracking).to eq "130801-1"
    expect(folder2.tracking).to eq "130801-2"
    expect(folder3.tracking).to eq "130801-3"
  end

  it "revision should contain tracking and version" do
    Timecop.freeze Time.parse("2012-12-21 12:00:00")
    folder = create(:flyboy_folder)
    expect(folder.revision).to eq "121221-1 1"
  end

  describe "#progress" do
    it "update task should update folder progress" do
      folder  = create(:flyboy_folder)
      task1 = create(:flyboy_task, taskable: folder, progress: 50)
      task2 = create(:flyboy_task, taskable: folder, progress: 100)
      expect(folder.reload.progress).to eq 75
      task1.progress = 100
      task1.save
      expect(folder.reload.progress).to eq 100
    end

   it "delete task should update folder progress" do
      folder  = create(:flyboy_folder)
      task1 = create(:flyboy_task, taskable: folder, progress: 50)
      expect(folder.reload.progress).to eq 50
      task1.destroy
      expect(folder.reload.progress).to eq 0
    end

    it "should be 0 if new folder" do
      expect(Dorsale::Flyboy::Folder.new.progress).to eq 0
    end
  end

  describe "states" do
    it "initial state should be open" do
      expect(Dorsale::Flyboy::Folder.new.status).to eq "open"
    end

    it "open folder can be closed" do
      folder = create(:flyboy_folder, status: "open")
      expect(folder.close).to be true
      expect(folder.status).to eq "closed"
    end

    it "closed folder can be reopened" do
      folder = create(:flyboy_folder, status: "closed")
      expect(folder.open).to be true
      expect(folder.status).to eq "open"
    end

    it "open folder with undone tasks can't be closed" do
      folder = create(:flyboy_folder, status: "open")
      task = create(:flyboy_task, taskable: folder, done: false)
      expect(folder.close).to be false
      expect(folder.status).to eq "open"
    end

    it "open folder with all tasks done can be closed" do
      folder = create(:flyboy_folder, status: "open")
      task = create(:flyboy_task, taskable: folder, done: true)
      expect(folder.close).to be true
      expect(folder.status).to eq "closed"
    end

  end

end
