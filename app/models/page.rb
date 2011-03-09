class Page < ActiveRecord::Base
  belongs_to :member
  
  has_many :documents, :dependent=> :destroy
  
  has_many :page_texts, :dependent=> :destroy
  accepts_nested_attributes_for :page_texts, :allow_destroy => true
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  validates_inclusion_of  :root_ind, :in => [true, false]
  
  validates_presence_of :url, :if => "template.blank?" and "layout.blank?"  
  validates_presence_of :template, :unless => "layout.blank?"
  validates_presence_of :layout, :unless => "template.blank?"
  
# before_validation :update_document
  before_save :update_document
  
  acts_as_tree :order => "page_order"
  
  DOC_PAGE_TYPE = "מסמך"
  BLOG_PAGE_TYPE = "מסמכים"
  ACTION_PAGE_TYPE = "פעולה"
  GALLERY_PAGE_TYPE = "גלריה"
  LEGAL_PARENTS = ["doc_page","home","gallery","video_room","about","references", ""]

# getter for page_type which is a virtual attribute  
  def page_type
    case 
         when (!self.url.nil? and !self.url.blank?)  then
               ACTION_PAGE_TYPE
         when !self.template.index("doc_page").nil? then 
              DOC_PAGE_TYPE
         when !self.template.index("blog").nil? then
              BLOG_PAGE_TYPE
         when !self.template.index("home").nil? then
              DOC_PAGE_TYPE
         when !self.template.index("gallery").nil? then
              GALLERY_PAGE_TYPE
         when !self.template.index("video_room").nil? then
              DOC_PAGE_TYPE
         when !self.template.index("about").nil? then
              DOC_PAGE_TYPE
         when !self.template.index("references").nil? then
              GALLERY_PAGE_TYPE
         else
              BLOG_PAGE_TYPE
    end
  end
  
# getters for page_texts attributes  
  def title
      pt = page_text_by_current_language
      unless pt.nil?
          return pt.title 
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
  
  def meta_title
      pt = page_text_by_current_language
      unless pt.nil?
          return pt.meta_title
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
  
  def meta_description
     pt = page_text_by_current_language
      unless pt.nil?
          return pt.meta_description
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
  
  def meta_keywords
      pt = page_text_by_current_language
      unless pt.nil?
          return pt.meta_keywords
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end 
  
  def author
      pt = page_text_by_current_language
      unless pt.nil?
          return pt.author 
      else
          return ESTEAM_NO_LANGUAGE_TXT
      end
  end
  
  def publish_date
      pt = page_text_by_current_language
      unless pt.nil?
          return pt.publish_date
      else
          return Date.today
      end
  end 
# end getters of page_texts attributes
  
  private
  
  def page_text_by_current_language
      self.page_texts.select{|pt| pt.language == I18n.locale.to_s}.first
# No need to read from database again. Info is in the array  
#  self.page_texts.find_by_language(I18n.locale.to_s)
  end
  

  def update_document
      if self.page_type == DOC_PAGE_TYPE  or self.page_type == GALLERY_PAGE_TYPE      
          if self.documents.first.nil?
            @doc =  self.documents.build
          else
            @doc = self.documents.first
          end
          
          @doc.name = self.name
          @doc.member = self.member
          @doc.publish_date = self.page_texts.first.publish_date
          @doc.save
          
          self.page_texts.each do | pt|
             
             @dt = @doc.document_texts.find_by_language(pt.language)
             if @dt.nil?
                @dt = @doc.document_texts.build
             end
             @dt.language = pt.language
             @dt.title = pt.title
             @dt.abstract = pt.meta_description
             @dt.tags = pt.meta_keywords
             @dt.author = pt.author
             @dt.save
          end
          
      end
  end 
  
end
