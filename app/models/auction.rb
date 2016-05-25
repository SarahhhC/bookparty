class Auction < ActiveRecord::Base
    belongs_to  :user
    belongs_to  :sellbook
end