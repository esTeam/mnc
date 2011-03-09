class PostText < ActiveRecord::Base
   belongs_to :post
   
   validates_presence_of   :language
   validates_uniqueness_of :language,:scope => [:post_id]
end
