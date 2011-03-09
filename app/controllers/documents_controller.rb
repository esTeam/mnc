class DocumentsController < ApplicationController

  layout 'admin'
  
  # Rather than doing Page.find(params[:id]) in all the actions that need
  # to, just use a before filter. This makes it obvious which actions need
  # a Page.
  before_filter :find_page
  
  # GET /documents
  # GET /documents.xml
  def index
    session[:return_to] = request.request_uri                                                                            
    @docs = Document.all_recent_by_page(params[:page_id])                           
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @docs }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    session[:return_to] = request.request_uri 
    @doc = Document.find(params[:id])  
    respond_to do |format|
       format.html  # show.html.erb
       format.xml  { render :xml => @doc }
    end   
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    @doc = Document.new
 #  create one occurance of document_texts nested model, for the first language          
    dt = @doc.document_texts.build
    dt.language = I18n.locale.to_s
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @doc }
    end 
  end
  
  # GET /documents/1/edit
  def edit
    @doc = Document.find(params[:id])
    if @doc.document_texts.find_by_language(I18n.locale.to_s).nil?
       dt = @doc.document_texts.build
       dt.language = I18n.locale.to_s
    end
  end

  # POST /documents
  # POST /documents.xml
  def create
    @doc = Document.new(params[:document])
    @doc.member = @current_user
    @doc.page = @page 
    
    respond_to do |format|
      if @doc.save
        flash[:notice] = "#{@action_success_message}"
        format.html { redirect_to page_document_url(@doc.page,@doc) }
        format.xml  { render :xml => @doc, :status => :created, :location => @doc }
      else
        @page=Page.find(params[:page_id])
        format.html { render :action => "new"}
        format.xml  { render :xml => @doc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
    @doc = Document.find(params[:id])
    @doc.member = @current_user
    
    respond_to do |format|
      if @doc.update_attributes(params[:document])
        flash[:notice] = "#{@action_success_message}"
         format.html { redirect_to  session[:return_to] }
 #        format.html { redirect_to page_document_url(@doc.page,@doc) }
         format.xml  { head :ok }
      else
        unless params[:reorder_ind]=="true"
           format.html { render :action => "edit" }
        else
           format.html { render :action => "reorder_posts" }
        end   
        format.xml  { render :xml => @doc.errors, :status => :unprocessable_entity }
      end
    end
  end
  
   
  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @doc = Document.find(params[:id])
    @page = @doc.page
    @doc.destroy

    respond_to do |format|
      format.html { redirect_to admin_show_page_url(@page)  }
      format.xml  { head :ok }
    end
  end
  
  # GET
  def reorder_posts
    @doc = Document.find(params[:id])
  end
  

private

    def find_page
       @page = Page.find_by_id(params[:page_id])
    end

end
