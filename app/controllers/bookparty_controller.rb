class BookpartyController < ApplicationController
  def signup
  end
    
  def signup_complete
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
    
  #태그 검색바의 값 받아서 매물리스트 뿌려주는 페이지(태그검색 결과페이지)
  def tagresult
      @tagSearch = params[:tagSearch]
      #sellbook & sellbooks_tags 조인하여 해당하는 행 리턴
      @sellbook = Sellbook.joins(:tags).where(tags:{tagname: @tagSearch}).take
      
      if @sellbook.nil?
          @showno = "존재하지 않는 태그입니다."
          @showyes = @tagSearch
          @sellbook = Sellbook.all
      else
          @showyes = @tagSearch
          #view에서 뿌려주기 위해
          @sellbook = Sellbook.joins(:tags).where(tags:{tagname: @tagSearch})
      end
  end
	  
  def storebookinfo
  end
    
  def storebookinfo_complete
    sellbook = Sellbook.new
    sellbook.user_id = params[:user_id]
    sellbook.booktitle = params[:booktitle]
    sellbook.book_image = params[:image_file]
    sellbook.bookauthor = params[:bookauthor]
    sellbook.bookpublisher = params[:bookpublisher]
    sellbook.bookprice = params[:bookprice]
    sellbook.nowbookprice = params[:nowbookprice]
    sellbook.bookstate = params[:bookstate]
    
    booksellterm_date = Date.strptime(params[:booksellterm_date],'%m/%d/%Y').strftime('%Y-%m-%d')
    booksellterm =  booksellterm_date + " " + params[:booksellterm_time] + ":00"
    #string -> 시간형태 -> 정수형으로 바꿔서 booksellterm으로 디비에 박기
    sellbook.booksellterm = DateTime.parse(booksellterm).to_i
    
    #hashtag 받아와서 처리 - hashtag ','로 split해서 tags배열에 저장
    list = params[:hashtag].split(",")
    #각 tag마다 Tags저장 + Sellbooks_Tag 디비에 저장
    list.each do |t|
        #tokenizer 한거를 Tag db에 넣는다
        hashtag = Tag.create(:tagname => t)
        sellbook.tags << hashtag
    end
    sellbook.save
    redirect_to '/bookparty/search'
  end
    
  def auction_price_update
    
    sellbook_update = Sellbook.find(params[:id])
    sellbook_update.bookprice = params[:bookprice] #입찰가 받아오기 update
    sellbook_update.save
    
    #auction참여 기록 남기기
    #판매자가 입찰 참여 못하도록 하는 부분 추가 필요 
    auction_update = Auction.where(user_id: session[:user_id], sellbook_id: params[:id]).take
    if auction_update.nil?  #경매에 처음 참여한다면 
      auction = Auction.new #새로 auction기록을 남기고 저장
      auction.user_id = session[:user_id]
      auction.sellbook_id = params[:id]
      auction.auctionprice = params[:bookprice]
      auction.save
    else  #경매에 참여한 기록이 있다면
      auction_update.auctionprice = params[:bookprice]  #가격만 업데이트해준다
      auction_update.save
    end

    render :json => {"result" => "success", "sellbook" => sellbook_update}
  end
  
  def my_page
    @userid = session[:user_id]
    @username = User.find(@userid).username
    
    #current-user가 판매할 책 - 남은시간의 "최신순"으로 정렬시킨다 
    @sellbook = Sellbook.where(user_id: @userid).order('booksellterm ASC')
    
    #current-user가 참여한 경매 리스트
    @auction = Auction.where(user_id: @userid)
    
    @close = Array.new
  end
end