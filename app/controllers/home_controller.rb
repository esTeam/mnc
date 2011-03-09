class HomeController < ApplicationController

layout "home"

 def index
   
   redirect_to fetch_page_by_name_url(:page_name =>"Home")
  
 end
 
end
