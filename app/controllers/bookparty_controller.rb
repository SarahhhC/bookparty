class BookpartyController < ApplicationController
    def signup
    end
    
    def signup_complete
        #빈값 확인 --> ""로 확인 / 생성확인 --> .nil?로 확인
        if params[:username] == ""
          redirect_to '/bookparty/signup', alert: '정보미기입'
        elsif params[:username] != ""
            #이메일 중복 확인
            usermail_exist_check = User.find_by_usermail(params[:usermail])
            if usermail_exist_check
              redirect_to '/bookparty/signup', alert: '이메일이 이미 존재합니다.'
            elsif
              user = User.new
              user.username = params[:username]
              user.usermail = params[:usermail]
              user.userpw = params[:userpw]
              user.userschool = params[:userschool]
              user.userphone = params[:userphone]
              user.save
              redirect_to '/bookparty/login'
            end
        end
    end
    
    def login
    end
 
    def login_complete
        u = User.where(usermail: params[:usermail])[0]
        if u.nil?
          flash[:alert] = "Incorrect usermail or password."
          redirect_to :back
        else
          if u.userpw != params[:userpw]
            flash[:alert] = "Incorrect usermail or password."
            redirect_to :back
          else
            session[:user_id] = u.id
            flash[:alert] = "Successfully logged in."
            redirect_to '/bookparty/search'
          end
        end
    end

    def logout
        reset_session
        redirect_to '/bookparty/login'
    end
    
    #메인 검색페이지입니다
    def search
        @userid = session[:user_id]
        #비회원일때
        if @userid.nil?
          @alertNonUser = "비회원 이십니다."
        #로그인했을 때
        else 
          @username = User.find(@userid).username
        end
    end
    
    def storebookinfo
    end
    
    def storebookinfo_complete
        sellbook = Sellbook.new
        sellbook.user_id = params[:user_id]
        sellbook.booktitle = params[:booktitle]
        sellbook.bookauthor = params[:bookauthor]
        sellbook.bookpublisher = params[:bookpublisher]
        sellbook.bookprice = params[:bookprice]
        sellbook.bookstate = params[:bookstate]
        sellbook.booksellterm = params[:booksellterm] #남은 기간 ~일
        
        #hashtag받아와서 처리
        
        sellbook.save
        
        redirect_to '/bookparty/search'
    end
end
