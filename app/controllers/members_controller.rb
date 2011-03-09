class MembersController < ApplicationController
 
  layout "admin"
  
  # GET /members
  # GET /members.xm
  def index
    @members = Member.all(:order=> "created_at DESC")
    render :layout => 'posts'
  end
  
  def show_blog 
    @member = Member.find(params[:id]) 
    @posts = @member.posts.my_recent_posts(params[:id])
  end
  
end
