class Gmail< ActiveRecord::Base
  require 'gmail'

  def send_mail(address, title, contents)
    gmail = Gmail.connect("joytutu29@gmail.com","308tutu99")
    puts gmail.logged_in?
    gmail.deliver do
      to address
      subject title
      text_part do
        body  contents
      end
    end
  
    gmail.logout
  end
  
  send_mail(User.find(session[:user_id]).usermail, "[@책파리]판매성공", "책파리를 방문해 판매된 목록을 확인하세요!")
  send_mail(User.find(session[:user_id]).usermail, "[@책파리]구매성공", "책파리를 방문해 구매한 목록을 확인하세요!")
end

