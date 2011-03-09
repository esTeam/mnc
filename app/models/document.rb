class Document < ActiveRecord::Base
   belongs_to :member
   belongs_to :page
   
#  posts are loaded according to location
#  posts will be deleted when document is deleted   
   has_many :posts, :order=>"location", :dependent=> :destroy , :autosave => true
   accepts_nested_attributes_for :posts
   
   has_many :document_texts, :dependent=> :destroy
   accepts_nested_attributes_for :document_texts, :allow_destroy => true
   
   validates_presence_of   :name  
   validates_uniqueness_of :name
   
   before_save :auto_update
   before_create :auto_update
   
  
   
# getters for document_texts attributes  
  def title
      dt = doc_text_by_current_language
      unless dt.nil?
          return dt.title 
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
    
  def abstract
      dt = doc_text_by_current_language
      unless dt.nil?
          return dt.abstract
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
  
  def author
     dt = doc_text_by_current_language
      unless dt.nil?
          return dt.author
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
  
  def tags
      dt = doc_text_by_current_language
      unless dt.nil?
          return dt.tags
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end 
# end getters of document_texts attributes
  
   def first_published_post
       posts.each do | post|
           if post.status == "Published"
              return post
           end
       end 
       return nil   
   end
   
   def each_published(&block)
      posts.each do | post|
        if post.status == "Published"
             yield(post)
        end
      end
    end
    
    def published_count
        count = 0
        posts.each do | post|
            if post.status == "Published"
               count += 1
            end
        end 
        return count   
    end 
    
# define a static method (<class name>.<method name>). Static method can be executed without an object.

# select all docs with no condition on status
   def Document.all_recent
       self.all(:order=> "status, updated_at DESC, title")
   end
   
   def Document.all_recent_by_page(page)
       self.find_all_by_page_id(page, :order=> "updated_at DESC")
   end
   
   def Document.all_recent_published        
        self.find_all_by_status("Published", :order=> "publish_date DESC")  
   end

# select only published docs   
   def Document.published_recent_by_page(page)       
       
           self.find(:all, 
                     :conditions => ["documents.status=? and documents.page_id=?", 
                                      "Published", "#{page}"],
                     :order => "publish_date DESC") 
       
   end
   
   def Document.published_recent_by_date(month_and_year,page)
      unless month_and_year.nil?
         self.find(:all, 
                   :conditions => ["documents.status=? and
                                    documents.page_id=? and 
                                    documents.month_and_year=?", 
                                    "Published", "#{page}", "#{month_and_year}"],
                   :order => "publish_date DESC") 
      end   
   end

# select archive dates for published documents   
   def Document.get_update_month_and_year(page)

        self.find( :all, :select => 'DISTINCT month_and_year',
                         :conditions => ["documents.status=? and documents.page_id=? ","Published","#{page}"],
                         :order => "publish_date DESC")

   end 
   
   
   
# search document 
 def self.search(arg)
      
       condition_string = Array.new(["1=1"])
       condition_param  = Array.new
       
       unless arg[:search_tag].nil? or arg[:search_tag].blank?
              condition_string.concat([" and (1=2"])
              arg[:search_tag].each(',') do |word|
                unless word.blank?
                  word = word.chomp(',')
                  word = word.rstrip()
                  word = word.lstrip()
                  condition_string.concat([" or document_texts.tags LIKE ?"])
                  condition_param.concat(["%#{word}%"])
                end
              end
              condition_string.concat([")"])
       end
       unless arg[:search_word].nil? or arg[:search_word].blank?
              condition_string.concat([" and (document_texts.title LIKE ? or document_texts.abstract LIKE ?)"])
              condition_param.concat(["%#{arg[:search_word]}%","%#{arg[:search_word]}%" ])

       end
          
       if condition_param.empty?
         return 
       else
         unless arg[:status].nil? or arg[:status].blank?
                 condition_string.concat([" and documents.status = ?"])
                 condition_param.concat(["#{arg[:status]}"])
         end
         condition_param.insert(0, condition_string.join)
         self.find(:all,
           :joins => 'LEFT OUTER JOIN document_texts ON document_texts.document_id = documents.id',
           :group => 'documents.id',
           :include => :document_texts,
           :conditions => condition_param)
       end 

   end
 
 private

  def doc_text_by_current_language
       self.document_texts.select{|dt| dt.language == I18n.locale.to_s}.first
# No need to read from database again. Info is in the array  
#      self.document_texts.find_by_language(I18n.locale.to_s)
  end
  
 
 #
 # last minute update
 #
   def auto_update
 #     if publish_date is empty, load publish_date with current date or created_at.
 #        Current date is needed since during create, the field created_at is empty. 
       if self.publish_date.nil? or self.publish_date.blank?
          unless self.created_at.nil?
             self.publish_date = self.created_at
          else
             self.publish_date = Date.today
          end   
       end
       
       self.month_and_year = self.publish_date.strftime("%B %Y")
       
#  23/2 document is alwyas published
       self.status = "Published"

   end
   
end
