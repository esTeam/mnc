class Post < ActiveRecord::Base
   belongs_to :document
   belongs_to :member
   belongs_to :mugshot
   
   has_many :post_texts, :dependent=> :destroy
   accepts_nested_attributes_for :post_texts, :allow_destroy => true
    
   validates_presence_of   :name 
   validates_uniqueness_of :name,:scope => [:document_id]
   
   validates_numericality_of :location
   
   before_validation_on_create :auto_update_location, :auto_update_name
   before_save :auto_update_status
   
#   23/2 document is always in published status, no matter what is the status of its posts  
#   after_save :auto_update_doc_status
#   after_destroy :auto_update_doc_status

# getters for post_texts attributes  
  def title
      ptxt = post_text_by_current_language
      unless ptxt.nil?
          return ptxt.title 
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
  
  def content
      ptxt = post_text_by_current_language
      unless ptxt.nil?
          return ptxt.content
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
# end getters of post_texts attributes
  
# split movie_url to two virtual fields
    def movie_thumb_url
        movie_urls.split(',', 2).first unless movie_urls.nil?
    end
    def movie_home_url
        movie_urls.split(',', 2).last unless movie_urls.nil?
    end
# set movie_urls from the two virtual fields
    def movie_thumb_url=(name)
        furl, lurl = self.movie_urls.split(', ') unless movie_urls.nil?
        self.movie_urls = [name.strip, lurl].join(', ') unless furl == name.strip 
    end
    def movie_home_url=(name)
        furl, lurl = self.movie_urls.split(', ') unless movie_urls.nil?
        self.movie_urls = [furl, name.strip].join(', ') unless lurl == name.strip 
    end
    
# get movie url for youtube embedded play 
    def youtube_movie_embed
      str1 = "http://www.youtube.com/v/" 
      str2 = movie_home_url.split('v=',2).last unless movie_home_url.nil?
      str3 = "&hl=en_US&fs=1&"
      return [str1,str2,str3].join     
    end  
    
    def text_save(text)
        ptxt = post_text_by_current_language
        unless ptxt.nil?
            ptxt.content = text 
            ptxt.save
        else
            return ESTEAM_NO_LANGUAGE_TXT
        end
    end       
    def text_find_by_language(lang)
        self.post_texts.select{|ptxt| ptxt.language == lang}.first
# The latter is equivalent to:
#        self.post_texts.each do |ptxt|
#            if ptxt.language == lang  
#              return ptxt
#            end
#        end
    end
    
 private
 
  def post_text_by_current_language
      self.post_texts.select{|ptxt| ptxt.language == I18n.locale.to_s}.first
# No need to read from database again. Info is in the array      
#    self.post_texts.find_by_language(I18n.locale.to_s)
  end
  
 #
 # Automatic update of status
 #
   def auto_update_status 
       if self.status == "To Be Published"
         self.status = "Published"
       end  
   end
 #
 # Automatic update of order of post inside a document
 #
   def auto_update_location
     max = Post.maximum('location',
                        :conditions => ["posts.document_id = ?", "#{self.document.id}"])
     if max.nil?
        self.location = Integer(10)
     else
        self.location = Integer(max) + 10
     end
   end 
#
# name attribute is nil when image is inserted to a gallery page, thus needs to get a value to avoid an error
#
    def auto_update_name
     if name.nil? or name.blank?
        max = Post.maximum('id') || 0
        max = max + 1
        self.name = max.to_s
     end
    end  
 
 #
 # Automatic update of document status according to its posts status
 #
   def auto_update_doc_status
       unless Post.count(:conditions => ["posts.document_id = ? and posts.status=?",
                                         "#{self.document.id}", "Published"] )==0
          self.document.status = "Published"
       else
        self.document.status = ""
       end
       self.document.save       
   end

end
