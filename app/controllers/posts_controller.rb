class PostsController < ApplicationController

  layout 'admin'
  
  # Rather than doing Document.find(params[:id]) in all the actions that need
  # to, just use a before filter. 
  before_filter :find_document, :except =>:publish
  
  # GET /posts/1
  # GET /posts/1.xml
  def show
    session[:return_to] = request.request_uri 
    @post = Post.find(params[:id])
     
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
 #  create one occurance of page_texts nested model, for the first language      
    ptxt = @post.post_texts.build
    ptxt.language = I18n.locale.to_s
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    if @post.post_texts.find_by_language(I18n.locale.to_s).nil?
       ptxt = @post.post_texts.build
       ptxt.language = I18n.locale.to_s
    end
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.document = @doc
    @post.member=@current_user
    @post.status =""
    unless params[:post_text].nil?
        @post.text_find_by_language(I18n.locale.to_s).content = params[:post_text][:content]
    end
    
    respond_to do |format|
      if @post.save 
        flash[:notice] = "#{@action_success_message}"        
        format.html { redirect_to  session[:return_to] }
 #      format.html { redirect_to page_document_url(@doc.page,@doc)  }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
 
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])
    @post.member=@current_user
    @post.status = ""
   
# When the page is of "gallery" type the text parameter is nil and shall be set to space
    if params[:post_text].nil?
       params[:post_text]= " "
    end
    
    respond_to do |format|
      if @post.update_attributes(params[:post]) and 
         @post.text_save(params[:post_text][:content])
        flash[:notice] = "#{@action_success_message}"
        format.html { redirect_to  session[:return_to] }
 #       format.html { redirect_to page_document_url(@doc.page,@doc) } 
        format.xml  { head :ok }
      else
# In case of error @post will be presented on the screen with all values entered by the user.
# The content field of the post_text object, however, is not populated, because it is not part of params[:post].
# Therefore we populate it manually. But first the appropriate post_text object needs to be found.
        @post.text_find_by_language(I18n.locale.to_s).content = params[:post_text][:content]
        format.html { render :action => "edit" }   
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @doc = @post.document
    @post.destroy

    respond_to do |format|
      format.html { redirect_to  session[:return_to] }
#      format.html { redirect_to page_document_url(@doc.page,@doc) }
      format.xml  { head :ok }
    end
  end
  
  # GET /posts/1
  # GET /posts/1.xml
   def publish
     @post = Post.find(params[:id])
     @doc = @post.document
     
     respond_to do |format|
       if  @post.update_attributes(:status => "To Be Published")           
         flash[:notice] = "#{@action_success_message}"
         format.html { redirect_to  session[:return_to] }
 #        format.html { redirect_to page_document_url(@doc.page,@doc) }
         format.xml  { head :ok }
       else
         flash[:notice] = "#{@action_failure_message}"
         format.html { render :action => "show"}
         format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
       end
      end
   end
  
  private

    def find_document
      @doc = Document.find_by_id(params[:document_id])
    end

end
