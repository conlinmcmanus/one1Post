class UserMailer < ApplicationMailer
  default from: 'conlinmcmanus@gmail.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'https://one1post.herokuapp.com/'
    mail(to: @user.email, subject: 'Welcome to onePost!')
  end
end