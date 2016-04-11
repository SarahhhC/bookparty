class TagsSellbook < ActiveRecord::Base
    belongs_to  :sellbooks
    belongs_to  :tags
end
