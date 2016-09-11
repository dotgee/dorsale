require "prawn"
require "prawn/table"

class Dorsale::Flyboy::Roadmap < Prawn::Document
  include ::ActionView::Helpers::NumberHelper
  include ::Dorsale::TextHelper

  attr_accessor :tasks

  def initialize(tasks)
    super(:page_layout => :landscape)
    @tasks = tasks
  end

  def build
    font_size 10
    text "Plan d'actions au #{I18n.l(Time.zone.now.to_date)}", :size => 20
    move_down(10)
    display_tasks(@tasks)
  end

  def display_tasks(tasks)
    display = [[
      "Taskable",
      "Type",
      "Avancement taskable",
      "Tâche",
      "Avancement tâche",
      "Echéance"
    ]]

    tasks.each do |task|
      display << [
        task.taskable.name,
        task.taskable.class.t,
        percentage(task.taskable.try(:progress)),
        task.name,
        percentage(task.progress),
        I18n.l(task.term)
      ]
    end

    table display
    move_down(10)
  end

end
