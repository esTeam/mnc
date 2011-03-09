# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110309133727) do

  create_table "ckeditor_assets", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename",       :limit => 80
    t.string   "thumbnail",      :limit => 20
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "type",           :limit => 40
    t.integer  "user_id"
    t.integer  "assetable_id"
    t.string   "assetable_type", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_id", "assetable_type", "type"], :name => "ndx_type_assetable"
  add_index "ckeditor_assets", ["assetable_id", "assetable_type"], :name => "fk_assets"
  add_index "ckeditor_assets", ["parent_id", "type"], :name => "ndx_type_name"
  add_index "ckeditor_assets", ["thumbnail", "parent_id"], :name => "assets_thumbnail_parent_id"
  add_index "ckeditor_assets", ["user_id", "assetable_type", "assetable_id"], :name => "assets_user_type_assetable_id"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "document_texts", :force => true do |t|
    t.string   "language"
    t.string   "title"
    t.string   "abstract"
    t.string   "author"
    t.string   "tags"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.date     "publish_date"
    t.integer  "page_id"
    t.integer  "member_id"
    t.string   "month_and_year"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "members", :force => true do |t|
    t.string   "login_name"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick_name"
    t.string   "email"
    t.date     "birth_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lwgo_mugshot_id"
    t.text     "my_passport"
  end

  create_table "mugshots", :force => true do |t|
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.string  "alt_text"
  end

  create_table "page_texts", :force => true do |t|
    t.string   "language"
    t.string   "title"
    t.string   "meta_title"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "author"
    t.date     "publish_date"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "template"
    t.string   "layout"
    t.string   "url"
    t.boolean  "root_ind"
    t.integer  "page_order"
    t.integer  "member_id"
  end

  create_table "post_texts", :force => true do |t|
    t.string   "language"
    t.string   "title"
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "member_id"
    t.integer  "mugshot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "document_id"
    t.integer  "location"
    t.string   "name"
    t.string   "movie_urls"
  end

  create_table "test", :id => false, :force => true do |t|
    t.string  "name", :limit => nil
    t.integer "id"
  end

end
