class Dorsale::UserMailer < ::Dorsale::ApplicationMailer
  def new_account(user, password)
    @user     = user
    @password = password
    mail(
      :to      => user.email,
      :subject => t("emails.user.new_account.title"),
    )
  end

end
