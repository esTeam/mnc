class SecurityController < ApplicationController
  layout 'admin_security'
  
  def login_logout
  render :login_logout
  end
  
  def login 
    unless @current_user.nil?
	    redirect_to admin_url()  
    end
    if request.post? 
      @current_user = Member.find_by_login_name_and_password(params[ :login_name], params[:password]) 
      unless @current_user.nil? 
        session[:user_id] = @current_user.id 
        redirect_to admin_url()  
      end
    end
  end 

  def logout
   session[:user_id] = @current_user = nil
   redirect_to home_url
  end
  
end
