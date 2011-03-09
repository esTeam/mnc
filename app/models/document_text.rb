class DocumentText < ActiveRecord::Base
   belongs_to :document
   
   validates_presence_of   :language 
   validates_uniqueness_of :language,:scope => [:document_id]
   
   validates_presence_of  :title  
end
