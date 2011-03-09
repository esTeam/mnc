# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def strip_html_tags(str)
  #  str.gsub(/<\/?[^>]*>/, "")
     str.gsub(/<(?!(a|(\/a)))\/?[^>]*>/, "")  # The pattern defines string which starts with <, not followed by
                                              # a or /a, followed by / or any character except >.
                                              # The string must end with >.
  end
  
  def display(content)
    if content.nil? or content.blank?
      return "display:none;"
    else
      return "display:block;"
    end
  end
  
  def mark_word(string)
    tag = content_tag(:span, :class => "first_word") do 
       first_word(string, ' ')
    end 
    tag += cut_first_word(string, ' ')
  end
  
  def marquee_tag(tag, &block)
    if tag == 'description'
      content_tag(:marquee, :height => '16', :width => '500', :direction => 'left',
                  :scrolldelay => '0', :onmouseout => 'start();',
                  :onmouseover => 'stop();', :scrollAmount => '3', &block ) 
    else
      yield
    end
  end
  
  def special_tag(tag_type, arg, &block)
    if !arg[:id].nil?
      tag_name = arg[:id]
      type = :id
    end
    if !arg[:class].nil?
      tag_name = arg[:class]
      type = :class
    end
    tag = "<div class='no_shadow'><#{tag_type} #{type} = '#{tag_name}'>#{capture(&block)}</div></div>"
  #  tag = "<#{tag_type} #{type} = '#{tag_name}'>#{capture(&block)}</div>"  # No Shadow Version 
    concat(tag)                                                          
  end
      
  def pop_content_tag(tag, &block)	     
     content_tag(:span, :onclick => "Effect.toggle('#{tag}', 'blind'); return false;", &block )   
  end 
      
  def first_word(name, sep)
     first_word = ' '
     name.each(sep) do |word|
       unless word.blank?
         if first_word.blank?
           first_word = word.chomp(sep)
           return(first_word)
         end
       end
     end
  end
  
  def cut_first_word(name, sep)
    first_word = ' '
    rest = ' '
    name.each(sep) do |word|
      unless word.blank?
          if first_word.blank?
            first_word = word.chomp(sep)
          else
            rest += word
          end
      end
    end
    return rest
  end
  
  def doc_description(post)
    if post.document.abstract.nil? or post.document.abstract.blank?
       description = strip_html_tags(post.content[0...1000])
    else
       description = strip_html_tags(post.document.abstract)
    end
    description = "Problem with document contents" if description.nil?
    return description
  end
  
  def side_name(page, doc_id)
    if doc_id.nil? or doc_id.blank?
      return "<span class='first_word'></span>#{page.title}"
    else
      return "<span class='first_word'>תוכן</span> המסמך"
    end
  end
  
  def display_menu_item(page)
    case 
    when page.template == "gallery"
      link_to_remote h(page.title), {:url => refresh_page_url(page), 
        :method => :get, 
        :before => "show_spinner()", 
        :complete => "Element.hide('spinner')"}, 
        :class => "normal"
    when page.template == "doc_page"
      link_to_remote h(page.title), {:url => refresh_page_url(page), 
        :method => :get}, 
        :class => "normal"
    else
      link_to_function h(page.title), "Effect.toggle('children_#{page.id}', 'blind')"
    end
  end
    
    
  def display_flashes
    return if flash.blank? or flash.nil?
    flash_type = flash.keys.first.to_sym
 
    return content_tag(:div, :id => "flash_box", :class => "flash-wrapper") do
      content_tag(:div, flash[flash_type], :class => "flash #{flash_type}")
    end
  end
  
  
  def f_publish_date_select(f)
   f.date_select("publish_date", :start_year => 1990, :include_blank => true)
  end
  
  
  def date_localize_monthandyear(dateArg)
      I18n.localize(dateArg, :format => :monthandyear)
  end
  
  def date_localize_fulldate(dateArg)
      I18n.localize(dateArg, :format => :fulldate)
  end
  
  def back_button
#   The commented command is rails equivelent to the second command
#    link_to('חזור>>', :back , :class=>'back_button')
#   link_to('חזור>>', session[:return_to], :class=>'back_button')
   link_to(' ', request.env['HTTP_REFERER'], :class=>'back_button')
  end
  
  def icon(icon)
    if icon.nil? or icon.blank? or !File.exists?("public/images/#{icon}.gif")
      return ' '
    else
      return image_tag("#{icon}.gif", :class => "icon")
    end
  end
  
# helps hide tags on condition.
  def hidden_div_if(condition, attributes = {}, &block)
      if condition
         attributes["style" ] = "display: none"
      end
      content_tag("div" , attributes, &block)
  end
  
# helps removing nested attributes from a _form, by using javascript
# in parent model ":allow_destroy => true" should be set
# name = link text
  def link_to_remove_fields(name, f, div)
     f.hidden_field(:_delete) + link_to_function(name, "remove_fields(this,'#{div}')")
  end
  
# helps adding nested attributes to a _form, by using javascript 
  def link_to_add_fields(name, f, association)
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object,
               :child_index => "new_#{association}") do |builder| 
                    render("form_" + association.to_s, :f => builder)
                end
      link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  # helps creating the navigation bar to choose current language 
  # If confirmation is required before changing language, confirm_msg holds the message,
  #   else it should be false
    def language_navigation_bar(confirm_msg)

        content_tag(:div,:class=>"language_navigation") do
         ESTEAM_SUPPORTED_LANGUAGES.collect do |lang|
            locale = ESTEAM_SUPPORTED_LOCALES[lang]
            icon = "/stylesheets/images/#{locale}.png"
            if locale==I18n.locale.to_s
               cl="current_lang_link"
            else
               cl="other_lang_link"
            end

            current_url = request.request_uri
          # omit "locale=" followed by any char except space (\S) and may ends with a single "&"        
            current_url =current_url.sub(/locale=\S+&?/,"") 
            if current_url =~ /\?/
               current_url+= "&locale=#{locale}"
            else 
            current_url+= "?locale=#{locale}"
            end

            content_tag(:span,
                        link_to(image_tag(icon), current_url,:confirm => confirm_msg ),
                        :class=>cl)   

          end
        end
    end
end
