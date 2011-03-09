class MugshotsController < ApplicationController
  
  layout "admin"
  
  def index 
      @mugshots = Mugshot.find(:all, :conditions => "thumbnail is null")
  end
  
  def choose
      session[:return_to_choose] = true
      @mugshots = Mugshot.find(:all, :conditions => "thumbnail is null")
      @mugshot = Mugshot.new
      render :layout => false
  end
  
  def new
      session[:return_to_choose] = false
      @mugshot = Mugshot.new
  end
  
  def show
      @mugshot = Mugshot.find(params[:id])
      @thumbs= Mugshot.find_all_by_parent_id(params[:id])     
  end
  
  def edit  
      @mugshot = Mugshot.find(params[:id])  
  end
  
  def create
      @mugshot = Mugshot.new(params[:mugshot])
      if @mugshot.save
         flash[:notice] = @action_success_message
          if session[:return_to_choose]
             redirect_to choose_mugshots_url
          else
             redirect_to mugshots_url
          end
      else
          if session[:return_to_choose]
             render :action => 'choose',:layout => false
          else
             render :action => 'new'
          end
      end
  end
  
  def update
    @mugshot = Mugshot.find(params[:id])
    if @mugshot.update_attributes(params[:mugshot])
       flash[:notice] = @action_success_message
       if not session[:return_to].nil?
            redirect_to session[:return_to]
            session[:return_to] = nil
         else  
            redirect_to :action => 'show', :id => @mugshot
         end
    else
      render :action => 'edit'
    end
  end

  
  def destroy
    mugshot_link = Post.find_by_mugshot_id(params[:id])
    if mugshot_link.nil?
       Mugshot.find(params[:id]).destroy
       flash[:notice] = @action_success_message
    else
       flash[:notice] = "אין אפשרות למחוק תמונה. התמונה מקושרת לדף #{mugshot_link.document.page.name}"  
    end
    redirect_to :action => 'index'
  end
     
end 