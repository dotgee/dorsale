require "rails_helper"

RSpec.describe Dorsale::PolymorphicId do
  it "should return guid" do
    task = create(:flyboy_task)
    expect(task.id).to be_present
    expect(task.guid).to eq "Dorsale::Flyboy::Task-#{task.id}"
  end

  it "should return guid" do
    folder = create(:flyboy_folder)
    task   = build(:flyboy_task, taskable: nil)

    expect(folder.id).to be_present
    expect(task.taskable).to be_nil
    expect(task.taskable_id).to be_nil
    expect(task.taskable_type).to be_nil
    task.taskable_guid = folder.guid
    expect(task.taskable).to eq folder
    expect(task.taskable_id).to eq folder.id
    expect(task.taskable_type).to eq "Dorsale::Flyboy::Folder"
  end

  it "should return base_class in guid" do
    corporation = create(:customer_vault_corporation)
    expect(corporation.guid).to eq "Dorsale::CustomerVault::Person-#{corporation.id}"
  end

end
