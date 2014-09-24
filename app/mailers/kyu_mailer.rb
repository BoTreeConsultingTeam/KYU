class KyuMailer < ActionMailer::Base

  def report_abuse_mailer(user,question)
    @question = question
    @user = user
    mail(to: Settings.mail.default_url_options.support_email, from: user.email, subject: t('mailer.subject.report_abuse_notification'))
  end
end
