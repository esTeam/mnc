class Mugshot < ActiveRecord::Base
  has_many :posts

  has_attachment :content_type => [:image,'video/mpeg','video/x-msvideo'],
                 :storage => :file_system, 
                 :max_size => 50.megabyte,
                 :resize_to => 'x400>',
                 :thumbnails => {:thumb =>'x100>',:mini =>'x50>',:gallery=>'x400>',:normal =>'x200>' },
                 :processor => :Rmagick;

  validates_as_attachment
  
# setter and getter to enable deliver url to attachment_fu. 
# This url is converted to "io" object similar to StringIo, via UrlUpload.  
  def url=(value)
     if !value.nil? and !value.blank?
        self.uploaded_data=Urlupload.new(value)
     end  
  end 
  def url
  end

# Michal: could not override width & height getters,so developed specific methods
# get width/height for either a thumbnail or main mugshot.
# get_width("mini") to get width of :mini mugshot,
# get_width to get width of main mugshot 
  def get_width ( thumbnail = nil )        
      return thumbnail ? 
             Mugshot.find_by_parent_id_and_thumbnail(self.id, thumbnail).width :
             self.width
  end
  def get_height ( thumbnail = nil )        
      return thumbnail ? 
             Mugshot.find_by_parent_id_and_thumbnail(self.id, thumbnail).height :
             self.height
  end
  

# This callback is executed for each image being saved.i.e. for the main image and for each thumbnail   
  after_attachment_saved do |record|       
    if record.public_filename.index('_gallery')
       if record.width > 550
          require 'RMagick'
          full_filename=""
          full_filename = "#{RAILS_ROOT}/public#{record.public_filename}"
          img = Magick::Image.read("#{full_filename}").first
          img = img.resize_to_fit!(550,400)
   # img.write, writes new file and update exsiting file.
          img.write("#{full_filename}") 
          record.width = img.columns
          record.height = img.rows
          record.save
       end
    end   
  end

end
