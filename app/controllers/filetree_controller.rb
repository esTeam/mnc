class FiletreeController < ApplicationController
  
  layout 'admin_filetree'
  
  def open
    @domain_url = "http://#{request.host_with_port}"
    @dir=params[:dir]
    @g_parent=params[:parent]? params[:parent] : ""
    
    if  @g_parent.blank?
       @parent = @dir
    else
       @parent =  @g_parent+ "/" + @dir
    end
    
    
    @content = Filetree.new("public/"+@parent).get_content
    render :update do |page|
      page.replace_html  @dir, :partial => "open"
    end  
  end 
  
  def content
    
    @domain_url = "http://#{request.host_with_port}"
    @dir=params[:dir]
    @g_parent=params[:parent]? params[:parent] : ""
    
    if  @g_parent.blank?
       @parent = @dir
    else
       @parent =  @g_parent+ "/" + @dir
    end
    
    
    @content = Filetree.new("public/"+@parent).get_content
 
  end  
  
  def close
    @parent = params[:parent]? params[:parent] : ""
    @dir =params[:dir]
    render :update do |page|
      page.replace_html  @dir, :partial => "close"
    end  
  end 
end