class Dorsale::Flyboy::TaskMailer < ::Dorsale::ApplicationMailer
  def new_task(user, task)
    @author   = user
    @task = task
    mail(
      :to      => task.owner.email,
      :subject => t("emails.task.new.subject"),
    )
  end

  def term_email(task)
    @task = task
    mail(
      :to      => task.owner.email,
      :subject => t("emails.task.term.subject", task = task.name),
    )
  end

end
