class UserMailer < ApplicationMailer

  def send_notification(user, announcement)
    @user = user
    @announcement = announcement

    mail to: "#{@user.email}", subject: "#{@announcement.title}"
  end

end
