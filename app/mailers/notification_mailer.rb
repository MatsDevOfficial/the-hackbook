class NotificationMailer < ApplicationMailer
  def test_email
    @user = params[:user] || User.first
    mail(to: @user.email, subject: "The Hackbook: Test Email")
  end
end
