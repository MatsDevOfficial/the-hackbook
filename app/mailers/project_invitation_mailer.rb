class ProjectInvitationMailer < ApplicationMailer
  def invite
    @invitation = params[:invitation]
    @project = @invitation.project
    @invited_by = @invitation.invited_by

    mail(to: @invitation.email, subject: "You've been invited to join the club project: #{@project.name}")
  end
end
