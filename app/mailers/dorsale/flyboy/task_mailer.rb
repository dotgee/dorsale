class Dorsale::Flyboy::TaskMailer < ::Dorsale::ApplicationMailer
  def new_task(task, author)
    @task = task

    @locals = {
      :author    => author.to_s,
      :owner     => task.owner.to_s,
      :task_url  => flyboy_task_url(@task),
      :task_name => task.to_s,
    }

    mail(
      :to      => task.owner.email,
      :subject => t("task_mailer.new_task.subject", @locals),
    )
  end

  def term_email(task)
    @task = task

    @locals = {
      :owner     => task.owner.to_s,
      :task_url  => flyboy_task_url(@task),
      :task_name => task.to_s,
    }

    mail(
      :to      => task.owner.email,
      :subject => t("task_mailer.term_email.subject", @locals),
    )
  end

end
