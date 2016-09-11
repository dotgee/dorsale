require 'rails_helper'

describe Dorsale::Flyboy::Task do
  it { is_expected.to belong_to(:taskable) }
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to validate_presence_of :taskable}
  it { is_expected.to validate_presence_of :name}
  it { is_expected.to validate_presence_of :term}
  it { is_expected.to validate_presence_of :reminder}

  describe "default values" do
    before do
      @task = Dorsale::Flyboy::Task.new
    end

    it "#done should be false" do
      expect(@task.done).to be false
    end

    it "#reminter should be present" do
      expect(@task.reminder.present?).to be true
    end

    it "#term should be present" do
      expect(@task.term.present?).to be true
    end

    it "#progress should be 0" do
      expect(@task.progress).to eq 0
    end
  end

  describe '#validation' do
    it 'factory should be #valid?' do
      expect(create(:flyboy_task)).to be_valid
    end

    it 'should ensure that term >= reminder' do
      date = Time.zone.now.to_date
      task = build(:flyboy_task, reminder: date+1.day, term: date)
      expect(task).to_not be_valid
    end
  end

  describe '#snooze' do
    before do
      @today = Time.zone.now.to_date
      @task = build(:flyboy_task, reminder: @today - 5 , term: @today + 5)
    end

    context 'term not passed' do
      it "should snooze the reminder and term with default value" do
        @task.snooze
        expect(@task.reminder).to eq Time.zone.now.to_date + 2
        expect(@task.term).to eq Time.zone.now.to_date + 35
      end

      context 'reminder too far is the past' do
        it "should set reminder to today" do
          @task.reminder = @today - 30
          @task.term = @today + 1
          @task.snooze
          expect(@task.reminder).to eq Time.zone.now.to_date + 1
          expect(@task.term).to eq Time.zone.now.to_date + 1
        end
      end
    end

    context 'term passed' do
      before do
        @task.term = Time.zone.now.to_date - 2
      end

      it "should snooze the reminder and term with default value from current date" do
        @task.snooze
        expect(@task.reminder).to eq @today + 7
        expect(@task.term).to eq @today + 30
      end
    end

  end # describe '#snooze'

  describe ".delayed" do
    it "should have the scope" do
      expect(::Dorsale::Flyboy::Task).to respond_to :delayed
    end
    it "should return delayed unfinished tasks" do
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+1)
      task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-1, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-1, done: false)
      task_3 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-2, done: true)
      task_4 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-2, done: false)
      tasks = ::Dorsale::Flyboy::Task.delayed
      expect(tasks).to contain_exactly(task_2, task_4)
    end
  end
  describe ".today" do
    it "should have the scope" do
      expect(::Dorsale::Flyboy::Task).to respond_to :today
    end
    it "should return today unfinished tasks" do
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+1)
      task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date, done: false)
      tasks = ::Dorsale::Flyboy::Task.today
      expect(tasks).to contain_exactly(task_2)
    end
  end
  describe ".tomorrow" do
    it "should have the scope" do
      expect(::Dorsale::Flyboy::Task).to respond_to :tomorrow
    end
    it "should return tomorrow unfinished tasks" do
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date)
      task_1 = create(:flyboy_task, owner: @user1, term: Date.tomorrow, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Date.tomorrow, done: false)
      tasks = ::Dorsale::Flyboy::Task.tomorrow
      expect(tasks).to contain_exactly(task_2)
    end
  end
  describe ".this_week" do
    it "should have the scope" do
      expect(::Dorsale::Flyboy::Task).to respond_to :this_week
    end
    it "should return this week unfinished tasks" do
      Timecop.travel(2015, 5, 21, 12, 0, 0) do
        task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-7, done: false)
        task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+2, done: true)
        task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+2, done: false)
        task_3 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+3, done: false)
        task_4 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+5, done: false)
        tasks = ::Dorsale::Flyboy::Task.this_week
        expect(tasks).to contain_exactly(task_2, task_3)
      end
    end
  end
  describe ".next_week" do
    it "should have the scope" do
      expect(::Dorsale::Flyboy::Task).to respond_to :next_week
    end
    it "should return next week unfinished tasks" do
      Timecop.travel(2015, 5, 21) do
        task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date, done: false)
        task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+7, done: true)
        task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+7, done: false)
        task_3 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+9, done: false)
        task_4 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+12, done: false)
        tasks = ::Dorsale::Flyboy::Task.next_week
        expect(tasks).to contain_exactly(task_2, task_3)
      end
    end
  end
end
