class SitemapController < ApplicationController
  layout nil
  def sitemap
#    @xml = Builder::XmlMarkup.new                          
    @pages = Page.find(:all, 
                        :select => 'id, name, updated_at')
                          
  end

end