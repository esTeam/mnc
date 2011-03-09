# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "application"
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  before_filter :fetch_logged_in_user,
                :fetch_current_language,
                :flash_actions_messages,
                :fetch_page,
                :set_footer
  
  
   protected 
   def fetch_logged_in_user 
     return if session[:user_id].blank? 
     @current_user = Member.find_by_id(session[:user_id]) 
   end   
   
   def fetch_current_language 
       session[:locale] = params[:locale] if params[:locale]
       if session[:locale].nil?
          session[:locale] = I18n.default_locale
       end
       @current_lang_abbr = session[:locale]
       
   # set the locale 
      I18n.locale = session[:locale] || I18n.default_locale
 #     logger.debug "Locale: #{I18n.locale}"
      locale_path = "#{LOCALES_DIRECTORY}#{I18n.locale.to_s}.yml"
      unless I18n.load_path.include? locale_path
             I18n.load_path << locale_path
             I18n.backend.send(:init_translations)
      end
   # end handling locale
   end 
   
   def fetch_page
     unless params[:page_id].nil?
       @current_page = Page.find_by_id(params[:page_id])
       @meta_title = @current_page.meta_title
       @meta_keywords = @current_page.meta_keywords
       @meta_description = @current_page.meta_description
     end
   end
   
   def convert_formTag_dateSelect_to_date(obj)
      if obj.nil?
          return nil
      end
      if (obj['(1i)'].blank? and obj['(2i)'].blank? and obj['(3i)'].blank? )
          return nil
      end
# set 1 to day, if it is blank
      if obj['(3i)'].blank?
         obj['(3i)'] = "1"
      end
      return Date.new(obj['(1i)'].to_i,obj['(2i)'].to_i,obj['(3i)'].to_i)
   end
   
   def flash_actions_messages
     @action_success_message = "העדכון הסתיים בהצלחה"
     @action_failure_message = "העדכון נכשל"
   end
  
   def set_footer 
    p = Page.find_by_name('Footer')   
    if p.nil? 
       @footer_content = ' '
     else
       @footer_content = Document.find_by_page_id(p.id).posts.first
     end
   end
     
end
