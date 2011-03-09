module PagesHelper
    def build_tree(page, result)
      result += "<li> #{link_to h(page.name), admin_show_page_url(page)}</li>"
      result += "<ul>"
      for node in page.children 
        tree = ' '
        build_tree(node, tree)
        result += tree
      end
      result += "</ul>"
    end
    
  def page_edit_button(page)
     link_to('עדכן', edit_page_url(page)) 
  end
  def page_delete_button(page)
     err_msg = 'מחיקה מוחקת את הדף עם כל הדפים תחתיו, כל המסמכים והפרקים שקשורים אליו, בכל השפות שמומשו! אשר מחיקה'
     link_to('מחק', page, :confirm =>err_msg,:method => :delete) 
  end 
  
  def page_add_document_button(page)
     link_to('הוסף מסמך', new_page_document_url(page))
  end 
 
  
  def define_template_layout(type)
   case type
      when "מסמך" then 
           categories = ["doc_page", 
                         "home",
                         "about",
                         "gallery",
                         "video_room",
                         "references"]
      when "גלריה" then 
           categories = ["gallery",
                         "references"]
      when "מסמכים" then
           categories = ["blog"]
      when "פעולה" then
           categories = [""]
      else
          categories = ["",
                        "doc_page", 
                        "home",
                        "about",
                        "blog",
                        "gallery",
                        "video_room",
                        "references"]
    end
  end
  
  
  def f_select_template(f,type) 
      f.select("template", define_template_layout(type))
  end
  
  def f_select_layout(f,type)  
      f.select("layout", define_template_layout(type))
  end
  
  def page_show_location_message(page)
      message=""
      if @page.parent.nil?
        if @page.root_ind 
          message="הדף מופיע בתפריט עליון"
        else
          message="הדף הוא דף נחיתה"
        end
      end
      return message
  end
  
end
