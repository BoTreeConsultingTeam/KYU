class KyuMailer < ActionMailer::Base

  def report_abuse_mailer(user,question)
    @question = question
    @user = user
    mail(to: 'h.o.bhalani@gmail.com', from: "#{user.email}", subject: t('mailer.subject.report_abuse_notification'))
  end
end
