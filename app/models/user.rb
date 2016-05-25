class User < ActiveRecord::Base
    has_many    :sellbooks
    has_many    :auctions
end
