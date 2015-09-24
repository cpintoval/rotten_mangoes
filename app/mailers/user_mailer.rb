class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def farewell_email(user)
    @user = user
    @url = 'http://example.com/farewell'
    mail(to: @user.email, subject: 'Goodbye dear user!')
  end

end
