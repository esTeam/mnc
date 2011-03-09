ActionController::Routing::Routes.draw do |map|

#
# Named routes will take precedence over resources, when appear before them in routes.rb!
# 
  map.home 'home', :controller => 'home', :action => 'index'
  map.contactus 'contactus', :controller =>'contactus', :action => 'index'
#
# Admin routes
#
  map.login 'login', :controller => 'security', :action => 'login'
  map.logout 'logout', :controller => 'security', :action => 'logout'
  map.admin 'admin', :controller => 'admin', :action => 'index'
  map.admin_help 'admin_help', :controller => 'admin', :action => 'admin_help'
  map.admin_show_db 'admin_show_db', :controller => 'admin', :action => 'admin_show_db'
  map.admin_fix_database 'admin_fix_database', :controller => 'admin', :action => 'admin_fix_database'
  map.change_pass 'change_pass', :controller => 'admin', :action => 'change_pass'
  map.filetree_open 'filetree_open', :controller => 'filetree', :action => 'open'
  map.filetree_close 'filetree_close', :controller => 'filetree', :action => 'close'
# 
#  Named Routes for views-controller
#
  map.viewer 'main', :controller => 'site_views', :action => 'main'
  map.search 'search', :controller => 'site_views', :action => 'search'
  map.fetch_page_by_name 'fetch', :controller => 'pages', :action => 'redirect', :id => :page_name
  map.fetch_page 'fetch/:id', :controller => 'pages', :action => 'redirect'
  map.reveal_children 'reveal_children/:id', :controller => 'site_views', :action => 'reveal_children'
  map.refresh_page 'refresh_page/:id', :controller => 'site_views', :action => 'refresh_page'

#  
#  Routing resource for the application
#     
  map.resources :pages,
                :has_many => [:documents],
                :member => {:admin_show => :get},
                :collection => {:content_management=>:get}
                 
  map.resources :members,
                :has_many => [:posts, :documents]
                
  map.resources :documents,
                :has_many => [:posts],
                :member => {:reorder_posts => :get}
                 
  map.resources :posts,
                :member => {:publish => :get}
  map.resources :post_texts
               
  map.resources :mugshots,
                :has_many => [:posts],
                :collection => {:choose=>:get}
     
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
 
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect 'sitemap', :controller => "sitemap", :action => "sitemap"


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
