class ContactusController < ApplicationController
  
  layout 'contactus'
  
  def index
     @contact = Contact.new
     @current_page = Page.find_by_name('Contact')   
     if @current_page.nil? 
        @contact_details = ' '
     else
        @contact_details = Document.find_by_page_id(@current_page.id).posts.first
     end
  end
  
 #----------------------------------------------------
 # process email
 #----------------------------------------------------
  def send_mail
  
 # @contact handles the validity of the contact details. It does not really save to the database.
    @contact = Contact.new(params[:contact])
    flash[:notice] = ''
    if @contact.save
#      contact details are valid. lets send it.  
       if Notifications.deliver_contact(@contact)
          flash[:notice] = I18n.t('main.messages.email_success')
           redirect_to :action=> "index"
       else
          flash[:notice] =  I18n.t('main.errors.email_failed')
          render :action=> "index"
       end
    else
       render :action=> "index"
    end
  end
end



   