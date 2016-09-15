class BookpartyController < ApplicationController
  def noti
    Time.zone = 'Seoul'
    now = Time.zone.now #현재시간은 계속 업데이트 됨 - 업데이트 되는값을 계속 집어넣어줘야지
    sellbook = Sellbook.all
    sellbook.each do |x|
      deadline = x.booksellterm - now.to_i
      if deadline <= 0
        auction = Auction.where(sellbook_id: x.id, auctionprice: x.bookprice, finished: 0).take
        unless auction.nil?
          notification = Notification.new 
          notification.user_id = x.user_id
          notification.sellbook_id = x.id
          notification.seller_or_buyer = 1 #seller면 1
          notification.checked = 2 #확인 안 했으면 2
          notification.save
          auction.finished = 1
          auction.save
        end
           
        success = Auction.where(sellbook_id: x.id, user_id: session[:user_id], auctionprice: x.bookprice, finished: 1).take
        unless success.nil?
          notification = Notification.new 
          notification.user_id = session[:user_id]
          notification.sellbook_id = x.id
          notification.seller_or_buyer = 2 #seller면 1
          notification.checked = 2 #확인 안 했으면 2
          notification.save
          success.finished = 2
          success.save
        end
      end
    end

    unless session[:user_id].nil?
      count = Notification.where(user_id: session[:user_id], checked: 2).count
      unless count == 0 
        sold = Notification.where(user_id: session[:user_id], checked: 2, seller_or_buyer: 1)
        @soldcount = sold.count
        buyed = Notification.where(user_id: session[:user_id], checked: 2, seller_or_buyer: 2)
        @buyedcount = buyed.count
        unless @soldcount == 0
          @soldid = sold.take.sellbook_id
        end
        unless @buyedcount == 0
          @buyedid = buyed.take.sellbook_id
        end
      end
    end
 
    render :json => {"result" => "success", "soldcount" => @soldcount, "buyedcount" => @buyedcount, "sellid" => @soldid, "buyid" => @buyedid } 
  end

  def admin
    Time.zone = 'Seoul'
    @real = Time.current
    @transaction = Sellbook.all
  end

  def signup
  end
    
  def signup_complete
    if params[:username] == ""
      redirect_to '/bookparty/signup', notice: "정보미기입"
    elsif params[:usermail] == ""
      redirect_to '/bookparty/signup', alert: '정보미기입'
    elsif params[:userpw] == ""
      redirect_to '/bookparty/signup', alert: '정보미기입'
    elsif params[:userschool] == ""
      redirect_to '/bookparty/signup', alert: '정보미기입'
    elsif params[:userphone] == ""
      redirect_to '/bookparty/signup', alert: '정보미기입'
    elsif params[:username] != ""
      #이메일 중복 확인
      usermail_exist_check = User.find_by_usermail(params[:usermail])
      if usermail_exist_check
        redirect_to '/bookparty/signup', alert: '이메일이 이미 존재합니다.'
      elsif
        @user = User.new
        @user.username = params[:username]
        @user.usermail = params[:usermail]
        @user.userpw = params[:userpw]
        @user.userschool = params[:userschool]
        @user.userphone = params[:userphone]
        if @user.save
          WebsocketRails[:username].trigger 'create_success', @user
        end
        redirect_to '/bookparty/login'
      end
    end
  end
    
  def login
    unless session[:user_id].nil?
      redirect_to '/bookparty/search'
    end
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
      elsif params[:usermail] == "admin@admin"
        redirect_to '/bookparty/admin'
      else
        w = Warn.find_by_user_id(u.id)
        unless w.nil?
          if w.count > 2 
            redirect_to '/bookparty/search'
          else
            session[:user_id] = u.id
            flash[:alert] = "Successfully logged in."
            redirect_to '/bookparty/search'
          end
        else
          session[:user_id] = u.id
          flash[:alert] = "Successfully logged in."
          redirect_to '/bookparty/search'
        end
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
    if @userid
      WebsocketRails[:tasks].trigger 'create_success', @userid
    end
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
    @close = Array.new

    if @sellbook.nil?
      @showno = 'not exist'
      @sellbook = Sellbook.all.order('booksellterm ASC')
    else
      @showyes = @tagSearch
      #view에서 뿌려주기 위해
      @sellbook = Sellbook.joins(:tags).where(tags:{tagname: @tagSearch}).order('booksellterm ASC')
    end
  end
	  
  def storebookinfo
    if session[:user_id].nil?
      redirect_to '/bookparty/login'
    end
  end
    
  def storebookinfo_complete
    sellbook = Sellbook.new
    sellbook.user_id = params[:user_id]
    sellbook.booktitle = params[:booktitle] 
    sellbook.book_image = params[:image_file] #표지
    #sellbook.book_image2 = params[:image_file2] #뒷면
    #sellbook.book_image3 = params[:image_file3] #임의 
    sellbook.bookauthor = params[:bookauthor]
    sellbook.bookpublisher = params[:bookpublisher]
    sellbook.bookprice = params[:bookprice]
    sellbook.nowbookprice = params[:nowbookprice]
    sellbook.bookstate = params[:bookstate]
    sellbook.sellerip = params[:sellerip]
    booksellterm_date = Date.strptime(params[:booksellterm_date],'%m/%d/%Y').strftime('%Y-%m-%d')
    booksellterm =  booksellterm_date + " " + params[:booksellterm_time] + ":00+0900"
    #string -> 시간형태 -> 정수형으로 바꿔서 booksellterm으로 디비에 박기
    sellbook.booksellterm = DateTime.parse(booksellterm).to_i
    puts sellbook.booksellterm
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

  def auction_price_update #입찰버튼을 눌렀을 때! (매물리스트보다 더 최신이지. 더 갱신된 디비 값이겠지)
    sellbook_update = Sellbook.find(params[:id])
    #db가격보다 낮으면 업데이트 안되게 수정
    if params[:bookprice].to_i > sellbook_update.bookprice #두번째 case  - 입찰버튼을 눌렀을 그때의 디비값과 비교 
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
        auction.finished = 0
        auction.save
      else  #경매에 참여한 기록이 있다면
        auction_update.auctionprice = params[:bookprice]  #가격만 업데이트해준다
        auction_update.save
      end
      render :json => {"result" => "success", "sellbook" => sellbook_update}
    end
  end

  def exact_buy
    sellbook = Sellbook.find(params[:id])
    sellbook.booksellterm = 0
    sellbook.bookprice = sellbook.nowbookprice
    sellbook.save
    auction = Auction.new #새로 auction기록을 남기고 저장
    auction.user_id = session[:user_id]
    auction.sellbook_id = params[:id]
    auction.auctionprice = sellbook.nowbookprice
    auction.finished = 0
    auction.save

    render :json => {"result" => "success"}
  end

  def my_page
    if session[:user_id].nil?
      redirect_to '/bookparty/login'
    else
      @userid = session[:user_id]
      @username = User.find(@userid).username

      #current-user가 판매할 책 - 남은시간의 "최신순"으로 정렬시킨다
      @sellbook = Sellbook.where(user_id: @userid).order('booksellterm ASC')

      #current-user가 참여한 경매 리스트
      @auction = Auction.where(user_id: @userid)
      @close = Array.new
      @close_buy = Array.new
    end
  end

  def seller_page
    @showno = "존재하지 않는 사용자입니다."
    @name = params[:name]
    @close = Array.new
  end

  def add_time_complete
    sellbook = Sellbook.find(params[:sellbook_id])
    booksellterm_date = Date.strptime(params[:booksellterm_date],'%m/%d/%Y').strftime('%Y-%m-%d')
    booksellterm =  booksellterm_date + " " + params[:booksellterm_time] + ":00+0900"
    #string -> 시간형태 -> 정수형으로 바꿔서 booksellterm으로 디비에 박기
    sellbook.booksellterm = DateTime.parse(booksellterm).to_i
    puts sellbook.booksellterm
    #hashtag 받아와서 처리 - hashtag ','로 split해서 tags배열에 저장
    
    sellbook.save
    redirect_to '/bookparty/my_page'
  end

  def delete 
    @deletebook = Sellbook.find(params[:id])
    @deletebook.destroy

    redirect_to '/bookparty/my_page'
  end

  def warn #판매탭에서 구매자를 신고할 때
    x = Sellbook.find(params[:id])
    auction = Auction.where(sellbook_id: x.id, auctionprice: x.bookprice).take
    u = auction.user_id
    w = Warn.find_by_user_id(u)

    if w.nil?
      warn = Warn.new
      warn.user_id = u
      warn.warner = session[:user_id]
      warn.count = 1
      warn.save
    elsif
      w.count = w.count + 1
      w.warner = session[:user_id]
      w.save
    end

    redirect_to '/bookparty/my_page'
  end


  def warnn #구매탭에서 판매자를 신고할 때
    x = Sellbook.find(params[:id])
    u = x.user_id
    w = Warn.find_by_user_id(u)

    if w.nil?
      warn = Warn.new
      warn.user_id = u
      warn.warner = session[:user_id]
      warn.count = 1
      warn.save
    elsif
      w.count = w.count + 1
      w.warner = session[:user_id]
      w.save
    end

    redirect_to '/bookparty/my_page'
  end

  def auction_delete
    @auctiondelete = Auction.find_by_sellbook_id(params[:id])
    @auctiondelete.destroy

    redirect_to '/bookparty/my_page'
  end

  def modifybookinfo
    @book = params[:book]
  end

  def modifybookinfo_complete
    sellbook = Sellbook.find(params[:sellbook_id])
   
    sellbook.user_id = params[:user_id]
    sellbook.booktitle = params[:booktitle]
    sellbook.book_image = params[:image_file] #표지
    #sellbook.book_image2 = params[:image_file2] #뒷면
    #sellbook.book_image3 = params[:image_file3] #임의 
    sellbook.bookauthor = params[:bookauthor]
    sellbook.bookpublisher = params[:bookpublisher]
    sellbook.bookprice = params[:bookprice]
    sellbook.nowbookprice = params[:nowbookprice]
    sellbook.bookstate = params[:bookstate]
    sellbook.sellerip = params[:sellerip]
    booksellterm_date = Date.strptime(params[:booksellterm_date],'%m/%d/%Y').strftime('%Y-%m-%d')
    booksellterm =  booksellterm_date + " " + params[:booksellterm_time] + ":00+0900"
    #string -> 시간형태 -> 정수형으로 바꿔서 booksellterm으로 디비에 박기
    sellbook.booksellterm = DateTime.parse(booksellterm).to_i
    puts sellbook.booksellterm
    #hashtag 받아와서 처리 - hashtag ','로 split해서 tags배열에 저장
    list = params[:hashtag].split(",")
    #각 tag마다 Tags저장 + Sellbooks_Tag 디비에 저장
    list.each do |t|
      #tokenizer 한거를 Tag db에 넣는다
      hashtag = Tag.create(:tagname => t)
      sellbook.tags << hashtag
    end
    sellbook.save
  
    redirect_to '/bookparty/my_page'
  end

  def show_mac_address
    puts @mymacaddress
   
    @client_ip = request.ip
    @mac_address = get_mac_address(@client_ip)
  end 
end

