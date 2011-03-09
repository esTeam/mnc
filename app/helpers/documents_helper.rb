module DocumentsHelper
  
  def doc_show_link(name,page,doc)
     link_to(name, page_document_url(page,doc)) 
  end
  
  def doc_edit_button(page,doc)
     link_to('עדכן', edit_page_document_url(page,doc)) 
  end
  def doc_delete_button(doc)
     err_msg = 'מחיקה, מוחקת את המסמך עם כל הפרקים שלו וכל השפות שמומשו! אשר מחיקה'
     link_to('מחק', doc, :confirm => err_msg,:method => :delete) 
  end
  def doc_add_post_button(doc)
     link_to('הוסף פרק', new_document_post_url(doc))
  end
  def doc_reorder_posts_button(doc)
     link_to('סדר פרקים', reorder_posts_document_url(doc))
  end
  def doc_add_post_gallery_button(doc)
     link_to('הוסף תמונה', new_document_post_url(doc))
  end
  def doc_reorder_posts_gallery_button(doc)
     link_to('סדר תמונות', reorder_posts_document_url(doc))
  end
  def doc_back_to_page_button(page)
     link_to('חזור לדף', admin_show_page_url(page))
#     link_to('חזור<<', request.env['HTTP_REFERER'])
  end
  def doc_admin_title(doc)
      s = " עודכן לאחרונה בתאריך #{date_localize_fulldate(doc.updated_at.to_date)} על ידי #{doc.member.login_name}"
      if doc.status=="Published"
         s = "#{s}.<strong> המסמך שוחרר לפרסום</strong>"
      else
         s = "#{s}.<strong> המסמך נמצא בעבודה</strong>"
      end
      return s
  end
  def doc_info_title(doc)
      doc_info_string = ""
      
      unless doc.author.nil? or doc.author.blank?
        doc_info_string= "נכתב על ידי  #{doc.author} "
      end
      unless doc.publish_date.nil?
        unless doc.author.blank?
           doc_info_string+= " / " 
        end
        doc_info_string+=" פורסם בתאריך #{doc.publish_date}"
	  end
      return doc_info_string
   end
   
end
