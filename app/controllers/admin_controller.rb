class AdminController < ApplicationController
  
  layout 'admin'
  
  def index
    unless @current_user.nil?
       redirect_to content_management_pages_url
    else
	    redirect_to login_url()  
    end  
  end
  
  def change_pass
   if request.post? 
      @member = Member.find_by_login_name_and_password(@current_user.login_name , params[:old_password]) 
      if @member.nil?
         flash[:notice] = 'סיסמא נוכחית שגויה'
         return
      end 
      if(params[:password1].length <8 )
         flash[:notice] = 'סיסמא חייבת להיות בת 8 תווים לפחות'
         return
      end   
      if !(params[:password1] == params[:password2]) 
         flash[:notice] = 'סיסמא חדשה לא אומתה'
         return
      end  
      if @member.update_attribute('password', params[:password1])
         flash[:notice] = "#{@action_success_message}"
         redirect_to admin_url() 
      else
         flash[:notice] = "#{@action_failure_message}"
      end
             
    end    
  end
  
  def search 
      @docs = Document.search(
        :search_word => params[:search_word], 
        :search_tag => params[:search_tag])
      render 'documents/search_result_view'
  end
  
  def admin_show_db
      @pages = Page.all(:order => "id")
      @page_texts = PageText.all
      @docs = Document.all
      @doc_texts = DocumentText.all
      @post_texts = PostText.all
      @posts = Post.all
  end
  
  def admin_help
     render :layout => false
  end
  
# used in cases when data needs to be fixed during programming  
  def admin_fix_database
      PageText.all.each do |pt|
        if ESTEAM_SUPPORTED_LANGUAGES.include?(pt.language)
             pt.update_attributes(
               :language=>ESTEAM_SUPPORTED_LOCALES[pt.language]   )
        end
      end
      PostText.all.each do |ptxt|
        if ESTEAM_SUPPORTED_LANGUAGES.include?(ptxt.language)
           ptxt.update_attributes(
               :language=>ESTEAM_SUPPORTED_LOCALES[ptxt.language]   )
         end
      end
      DocumentText.all.each do |dt|
       if ESTEAM_SUPPORTED_LANGUAGES.include?(dt.language)
          dt.update_attributes(
               :language=>ESTEAM_SUPPORTED_LOCALES[dt.language]   )
       end
      end
      redirect_to admin_show_db_url(:type=>"all")
  end
end
