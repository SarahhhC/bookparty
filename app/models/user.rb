class User < ActiveRecord::Base
    has_many    :sellbooks
end
