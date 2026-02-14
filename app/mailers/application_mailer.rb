class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", ENV.fetch("WEBREUS_EMAIL_USER", "mats@lltool.overmans.nl"))
  layout "mailer"
end
