filename = "feuille_de_route_#{Time.zone.now.to_date}.csv"
response.headers["Content-Disposition"] = %(inline; filename="#{filename}")

CSV.generate do |csv|
  csv << [
    "Taskable",
    "Type",
    "Avancement taskable",
    "Tâche",
    "Avancement tâche",
    "Echéance"
  ]

  @tasks_without_pagination.each do |task|
    csv << [
      task.taskable.name,
      task.taskable.class.t,
      "#{task.taskable.try(:progress)} %",
      task.name,
      "#{task.progress} %",
      I18n.l(task.term),
    ]
  end
end
