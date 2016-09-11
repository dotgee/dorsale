filename = "feuille_de_route_#{Time.zone.now.to_date}.pdf"
response.headers["Content-Disposition"] = %(inline; filename="#{filename}")

::Dorsale::Flyboy::Roadmap.new(@tasks_without_pagination)
  .tap(&:build)
  .render
