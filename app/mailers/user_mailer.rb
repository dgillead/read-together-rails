class UserMailer < ApplicationMailer
  default from: 'darnell@readtogether.com'

  def invitation(email)
    mail(to: email, subject: "You've been invite to a discussion on Read Together!")
  end
end
