module PostsHelper
  def post_edit_button(doc,post)
    link_to('עדכן', edit_document_post_url(doc,post)) 
  end
  def post_image_edit_button(doc,post)
    link_to('עדכן', edit_document_post_url(doc,post)) 
  end
  def post_delete_button(post)
     err_msg = 'מחיקה מוחקת את הפרק בכל השפות שנכתב!  אשר מחיקה'
     link_to('מחק', post, :confirm => err_msg,:method => :delete) 
  end
  def post_publish_button(post)
    if post.status == "In work" or post.status.blank?
		 link_to( 'פרסם', publish_post_url(post))
	  end
  end
  def post_back_to_doc_button(page,doc)
      link_to('חזור למסמך', page_document_url(page,doc))
  end
  
  def post_amdin_title(post)
      s = " עודכן לאחרונה בתאריך #{date_localize_fulldate(post.updated_at.to_date)} על ידי #{post.member.login_name}"
      return s
  end

end
