class SiteViewsController < ApplicationController

layout :set_layout

def main
  if @current_page.nil?
     @error = I18n.t('main.errors.page_not_exist')
     @main_partials = [{:page_view => "error_page", :page_id => ' ', :error => @error}]  
  else 
# Determine main view and build variables applicable to the view 
    case
    when !params[:doc_id].nil?
        view = show_doc(params[:doc_id], @current_page.id)
    when !params[:month_and_year].nil?
        view = partial_blog(params[:month_and_year], @current_page.id)   
    else
        view = eval("#{@current_page.template}(@current_page.id)")
    end
# Build list of partials that constitute the page's main content
    @main_partials = [{:page_view => view, :page_id => @current_page.id, :error => @error}]
# Build list of partials that constitute the page's side content
    @side_partials = build_partials(@current_page.content)
  end
end

def search 
  brieves = Document.search(
    :status => "Published",
    :search_word => params[:search_word], 
    :search_tag => params[:search_tag])
  @current_page = Page.find_by_name('תוצאות חיפוש')
  eval("@doc_brieves#{@current_page.id} = brieves")
  @main_partials = [{:page_view => 'blog', :page_id => @current_page.id}]
  render :action => 'main', :layout => 'search' 
end

def refresh_page 
  @doc = Document.find_by_page_id(params[:id])
  @current_page = Page.find_by_id(params[:id])
  temp = "refresh_#{@current_page.template}(#{@current_page.id})"
#  logger.debug "Calling doc_page_refresh: #{temp}"
  view = eval("#{@current_page.template}_refresh(#{@current_page.id})") 
end

private

def home(page_id)
  # @content = Document.find_by_page_id(page_id)
  # if @content.published_count == 0 
  #  @error = "אנו מצטערים - הדף נמצא בבניה" 
  #  view = "error_page"
  # else
  #  view = "home" 
  # end
  view = "home" 
  return(view)
end

def about(page_id)
  @content = Document.find_by_page_id(page_id)
  if @content.published_count == 0 
    @error = I18n.t('main.errors.page_in_development')
    view = "error_page"
  else
    view = "about" 
  end
  return(view)
end

def blog(page_id)
  brieves = Document.published_recent_by_page(page_id)                 
  archive = Document.get_update_month_and_year(page_id)
  eval("@doc_brieves#{page_id} = brieves")
  eval("@blog_archive#{page_id} = archive")
  if brieves.empty? 
    @error = I18n.t('main.errors.page_in_development')
    view = "error_page"
  else
    view = "blog" 
  end
  return(view)
end

def partial_blog(month_and_year, page_id)                   
  brieves = Document.published_recent_by_date(month_and_year, page_id)
  archive = Document.get_update_month_and_year(page_id)
  eval("@doc_brieves#{page_id} = brieves")
  eval("@blog_archive#{page_id} = archive")
  return("blog")
end

def gallery(page_id)
  doc = Document.find_by_page_id(page_id) 
  if doc.published_count == 0 
    @error = I18n.t('main.errors.page_in_development')
    view = "error_page"
  else
    view = "gallery" 
  end
  eval("@doc#{page_id} = doc")
  return(view)                
end

def gallery_refresh(page_id)
  render :update do |page|
    page.replace_html "gallery", :partial => "gallery_refresh"
    page.call "StartGallery", @doc.published_count 
    page.call "scroller.swapContent", "smooth_scroller", 554, 60
    page.call "HighlightMenuItem", page_id
  end  
end

def video_room(page_id)
  doc = Document.find_by_page_id(page_id) 
  if doc.published_count == 0 
    @error = I18n.t('main.errors.page_in_development')
    view = "error_page"
  else
    description_post = doc.posts.find_by_name("Filmography")
    if description_post.nil?
      @doc_description = " "
    else
      @doc_description = description_post.content
    end     
    view = "video_room" 
  end
  eval("@doc#{page_id} = doc")
  return(view)                
end

def references(page_id)
  doc = Document.find_by_page_id(page_id) 
  if doc.published_count == 0 
    @error = I18n.t('main.errors.page_in_development')
    view = "error_page"
  else
    view = "references" 
  end
  eval("@doc#{page_id} = doc")
  return(view)                
end

def doc_page(page_id)
  doc = Document.find_by_page_id(page_id)
  if doc.published_count == 0 
    @error = I18n.t('main.errors.page_in_development')
    view = "error_page"
  else
    view = "doc_page" 
  end
  eval("@doc#{page_id} = doc")
  return(view)
end

def doc_page_refresh(page_id) 
  render :update do |page|
    page.replace_html "doc_page", :partial => "doc_page_refresh"
#    logger.debug "doc_page_refresh parameter: #{page_id}"
    unless @current_page.children.empty?
      page.call "Effect.toggle", "children_#{page_id}", "blind"
    end
    page.call "HighlightMenuItem", page_id
  end  
end

def show_doc(doc_id, page_id)
  doc = Document.find(doc_id)
  archive = Document.get_update_month_and_year(page_id)
  doc_page_attrs(doc)
  eval("@blog_archive#{page_id} = archive")
  eval("@doc#{page_id} = doc")
  return("show_doc")
end

def doc_page_attrs(doc)
  if doc.title.nil?
    @meta_title = "רצוי להוסיף כותרת למסמך"
  else
    @meta_title = doc.title
  end
  unless doc.tags.nil?
    @meta_keywords = doc.tags
  end
  unless doc.abstract.nil?
    @meta_description = doc.abstract
  end
end

def build_partials(embed_content)
# The content string contains the following construct (the square brakets are not part of the construct)
# [page_name].[post_number].[div_id],  [page_name].[post_number].[div_id], ... Any number of embedded pages.
# Page name may contain any number of blanks between words and the usual punctuation, except for dot (.).
  i = 0
  partials = Array.new
  contents = embed_content.split(/,\s+/) # Split string into elements seperated by ',' 
                                         # followed by any number of spaces.
                                         # The comma and the spaces are truncated!
  contents.each do |elem|
    temp = elem.split(/[\.]/)            # Split element into parts by '.'  
    page = Page.find_by_name(temp[0].gsub(/\s+/, ' '))  # Remove multiple spaces between words in name prior to fetching
                                                        # the page by name
    partials[i] = Hash.new
    if page.nil?
        partials[i][:page_id] = ' '
        partials[i][:page_view] = "error_page"
        partials[i][:error] = "הדף #{temp[0]} חסר"
    else
        partials[i][:page_view] = eval("#{page.template}(page.id)")
        if @error 
          partials[i][:error] = @error
        end
        partials[i][:page_id] = page.id
    end
    if temp.length == 3
        partials[i][:page_name] = temp[0]
        partials[i][:post_num] = temp[1]
        partials[i][:div_id] = temp[2]
    else
        partials[i][:page_name] = temp[0]
        partials[i][:div_id] = temp[1]
    end
    i += 1
  end

  return partials
end

def set_layout
  if @current_page.nil?
    "error_page"
  else
    @current_page.layout
  end
end
     
end
