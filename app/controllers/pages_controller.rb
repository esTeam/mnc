class PagesController < ApplicationController
  layout 'admin'
  
  def index
    @pages = Page.all(:order => "parent_id, page_order")
  end
  
  def content_management
    @pages = Page.roots
  end
  
  def redirect
    if params[:page_name].nil? or 
       params[:page_name].blank?
      @page = Page.find_by_id(params[:id])
    else      
      @page = Page.find_by_name(params[:page_name].gsub(/\s+/, ' ')) # Remove multiple spaces between words in page name
    end                                                              # prior to fetching the page by name
    case 
        when @page.nil?
          redirect_to viewer_url(:page_id => nil)
        when (@page.url.nil? or @page.url.blank?)
          redirect_to viewer_url(:page_id => @page.id)
        when @page.url.index('page:')
          page_name = @page.url.gsub("page:", "").rstrip()
          page_name = page_name.lstrip()
          redirect_to fetch_page_by_name_url(:page_name => page_name)
        when @page.url.index('fetch')
           redirect_to eval(@page.url)
        when @page.url.index('http:') == 1
          redirect_to eval(@page.url)
        else
          redirect_to eval("#{@page.url}(:page_id => @page.id)")
    end

#   This construct is saved to serve as an example: redirect_to eval("#{@page.content}(:page_id => #{@page.id})")
  end
  
  def show
   session[:return_to] = request.request_uri 
    @page = Page.find(params[:id])
  end
  
  def admin_show
    session[:return_to] = request.request_uri 
    @page = Page.find(params[:id])
    case @page.page_type
         when Page::DOC_PAGE_TYPE  then 
              render 'pages/doc_page_show'
         when Page::GALLERY_PAGE_TYPE  then 
              render 'pages/gallery_page_show'
         when Page::BLOG_PAGE_TYPE then
              render'pages/blog_page_show'
         when Page::ACTION_PAGE_TYPE then
              render'pages/action_page_show'
         else
           render'pages/blog_page_show'  
    end
  end
 
  def new
     @page = Page.new
     @page_type = params[:page_type]
     
 #   create one occurance of page_texts nested model, for the first language      
      pt = @page.page_texts.build
      pt.language = I18n.locale.to_s
  end
  
  
  def create
    @page = Page.new(params[:page])
    @page_type=@page.page_type
    @page.member = @current_user
    if @page.save
      flash[:notice] = "#{@action_success_message}"
      redirect_to admin_show_page_url(@page)
    else
      render :action => 'new' 
    end
  end
  
  def edit
    @page = Page.find(params[:id])
    @page_type=@page.page_type
    if @page.page_texts.find_by_language(I18n.locale.to_s).nil?
       pt = @page.page_texts.build
       pt.language = I18n.locale.to_s
    end
  end
  
  
  def update
    @page = Page.find(params[:id])
    @page.member = @current_user
    @page_type=@page.page_type
    if @page.update_attributes(params[:page])
      flash[:notice] = "#{@action_success_message}"
      redirect_to  session[:return_to]   
    else    
#      logger.debug "Page updated: #{@page.page_texts.inspect}, #{@page.template}"
      render :action => 'edit'   
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "#{@action_success_message}"
    redirect_to content_management_pages_url
  end
  
  
end
