require 'rails_helper'

describe Dorsale::Flyboy::ApplicationHelper, type: :helper do

  describe '#folder_color' do
    let!(:folder) {
      create(:flyboy_folder)
    }

    # ensure that tasks are filtered by group
    let!(:task_other_group_onalert) {
      create(:flyboy_task, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: false)
    }

    let!(:task_other_group_onwarning) {
      create(:flyboy_task, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date + 1.day, done: false)
    }

    #ensure tasks are filtered by folder
    let!(:other_folder) {
      create(:flyboy_folder)
    }
    let!(:task_onalert_for_other_folder) {
      create(:flyboy_task, taskable: other_folder, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: false)
    }
    let!(:task_onwarning_for_other_folder) {
      create(:flyboy_task, taskable: other_folder, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date + 1.day, done: false)
    }

    let!(:task_ontime) {
      create(:flyboy_task, taskable: folder, reminder: Time.zone.now.to_date + 1.day, term: Time.zone.now.to_date + 3.days, done: false)
    }
    let!(:task_finished) {
      create(:flyboy_task, taskable: folder, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: true)
    }

    context 'when all tasks are ontime or finished' do
      it 'should return ontime' do
        expect(folder_color(folder)).to eq('ontime')
      end

    end

    context 'when the folder is closed' do
      it 'should return finished' do
        folder_finished = create(:flyboy_folder, :status => "closed")
        expect(folder_color(folder_finished)).to eq('finished')
      end
    end

    context 'when at least one task is on warning' do
      let!(:task_onwarning) {create(:flyboy_task, taskable: folder, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date + 1.day, done: false)}
      it 'should return onwarning' do
        expect(folder_color(folder)).to eq('onwarning')
      end
    end

    context 'when at least one task is on alert' do
      let!(:task_onwarning) {create(:flyboy_task, taskable: folder, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: false)}

      it 'should return onalert' do
        expect(folder_color(folder)).to eq('onalert')
      end
    end
  end

  describe '#task_color' do
    # L’affichage de la couleur de la tâche dépend de son achèvement:
    # Si date jour < date relance alors noir
    it 'should return .ontime' do
      task = create(:flyboy_task, reminder: Time.zone.now.to_date + 1.day, term: Time.zone.now.to_date + 3.days, done: false)
      expect(task_color(task)).to eq('ontime')
    end
    # Si date relance < date jour < date butoir alors orange
    it 'should return .onwarning' do
      task = create(:flyboy_task, reminder: Time.zone.now.to_date - 1.day, term: Time.zone.now.to_date + 3.days, done: false)
      expect(task_color(task)).to eq('onwarning')
    end
    # Si date butoir < date jour alors rouge
    it 'should return .onalert' do
      task = create(:flyboy_task, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: false)
      expect(task_color(task)).to eq('onalert')
    end
    # Si action faite alors vert
    it 'should return .finished' do
      task = create(:flyboy_task, reminder: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: true )
      expect(task_color(task)).to eq('finished')
    end
  end

end
