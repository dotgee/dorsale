module Dorsale::Flyboy::TasksSummaryConcern
  extend ActiveSupport::Concern

  def setup_tasks_summary
    tasks = policy_scope(::Dorsale::Flyboy::Task)
      .where("(owner_id IS NULL and owner_type IS NULL) OR (owner_id = ? and owner_type = ?)", current_user.id, current_user.class)

    @delayed_tasks        = tasks.delayed
    @today_tasks          = tasks.today
    @tomorrow_tasks       = tasks.tomorrow
    @this_week_tasks      = tasks.this_week
    @next_week_tasks      = tasks.next_week
    @next_next_week_tasks = tasks.next_next_week
  end

end
