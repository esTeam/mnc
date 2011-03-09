class PageText < ActiveRecord::Base
   belongs_to :page
    
   validates_presence_of   :language 
   validates_uniqueness_of :language,:scope => [:page_id]
   
   validates_presence_of   :title
   
   before_save :auto_update
   
   private
   
   def auto_update
     if self.publish_date.nil? or self.publish_date.blank?
        self.publish_date = Date.today
     end
  end
   
end