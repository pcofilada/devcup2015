class ApplicationMailer < ActionMailer::Base
  default from: "hello@notify.me"
  layout 'mailer'
end
