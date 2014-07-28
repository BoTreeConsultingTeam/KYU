class KyuMailer < ActionMailer::Base
  def new_user_account_notification(user, password)
    @user = user
    @password = password
    mail(from: Settings.mail.default_url_options.support_email, to: @user.email, subject: t('mailer.user.subject.welcome'))
  end
end
