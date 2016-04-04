class BookpartyController < ApplicationController
  
    def signup
    end
    
    def signup_complete
        #nil 확인
        if params[:username].nil?
          redirect_to '/bookparty/signup', alert: '정보미기입'
        end
        
        #이메일 중복 확인
        usermail_exist_check = User.find_by_usermail(params[:usermail])
        if usermail_exist_check
          redirect_to '/bookparty/signup', alert: '이메일이 이미 존재합니다.'
        else
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
    
end