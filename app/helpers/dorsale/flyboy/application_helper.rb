module Dorsale::Flyboy::ApplicationHelper
  include ::Handles::SortableColumns::InstanceMethods

  def tasks_for(taskable)
    @filters = ::Dorsale::Flyboy::SmallData::FilterForTasks.new(cookies)

    order ||= sortable_column_order do |column, direction|
      case column
      when "name", "status"
        %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
      when "progress", "term"
        %(dorsale_flyboy_tasks.#{column} #{direction})
      else
        params["sort"] = "term"
        "dorsale_flyboy_tasks.term ASC"
      end
    end

    tasks = ::Dorsale::Flyboy::Task.where(taskable: taskable)
    tasks = @filters.apply(tasks)
    tasks = tasks.order(order)

    render "dorsale/flyboy/tasks/tasks_for_taskable", tasks: tasks, taskable: taskable
  end

  def show_tasks_summary
    render "dorsale/flyboy/tasks/summary"
  end

  def task_color(task)
    return "finished" if task.done
    return "ontime"   if task.reminder > Time.zone.now.to_date
    return "onalert"  if task.term     < Time.zone.now.to_date
    return "onwarning"
  end

  def folder_color(folder)
    return "onalert"   if ::Dorsale::Flyboy::Task.where(taskable: folder).where('done = ? AND term < ?', false, Time.zone.now.to_date).count > 0
    return "onwarning" if ::Dorsale::Flyboy::Task.where(taskable: folder).where('done = ? AND term > ? AND reminder < ?', false, Time.zone.now.to_date, Time.zone.now.to_date).count > 0
    return "finished"  if folder.closed?
    return "ontime"
  end

  def flyboy_status_for_filters_select
    {
      Dorsale::Flyboy::Folder.t("status.all")    => "",
      Dorsale::Flyboy::Folder.t("status.open")   => "open",
      Dorsale::Flyboy::Folder.t("status.closed") => "closed",
    }
  end

end
