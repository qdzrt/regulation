class UsersMailer < ApplicationMailer

  def reset_password(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: '密码重置')
  end

  def create_notify(name, email, password)
    @name = name
    @email = email
    @pasword = password
    mail(to: @email, subject: '欢迎使用')
  end
end
