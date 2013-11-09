# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131108202504) do

  create_table "authors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "full_name"
    t.text     "bio",        :limit => 16777215
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "category_title_list_memberships", :force => true do |t|
    t.integer  "title_list_id"
    t.integer  "category_id"
    t.integer  "position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "category_title_list_memberships", ["category_id"], :name => "index_category_title_list_memberships_on_category_id"
  add_index "category_title_list_memberships", ["title_list_id"], :name => "index_category_title_list_memberships_on_title_list_id"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "contributions", :force => true do |t|
    t.integer  "author_id"
    t.integer  "title_id"
    t.string   "what"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "copies", :force => true do |t|
    t.integer  "edition_id"
    t.integer  "cost_in_cents"
    t.integer  "price_in_cents"
    t.text     "notes"
    t.integer  "owner_id"
    t.boolean  "is_used"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.datetime "inventoried_when"
    t.datetime "deinventoried_when"
    t.string   "status"
    t.integer  "invoice_line_item_id"
  end

  add_index "copies", ["edition_id"], :name => "index_copies_on_edition_id"
  add_index "copies", ["owner_id"], :name => "index_copies_on_owner_id"

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "distributors", :force => true do |t|
    t.string   "name"
    t.string   "our_account_number"
    t.text     "notes"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "editions", :force => true do |t|
    t.string   "isbn13"
    t.string   "isbn10"
    t.integer  "year_of_publication"
    t.string   "format"
    t.boolean  "in_print"
    t.text     "notes",               :limit => 16777215
    t.integer  "title_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "cover"
    t.integer  "list_price_cents"
    t.integer  "publisher_id"
  end

  add_index "editions", ["publisher_id"], :name => "index_editions_on_publisher_id"
  add_index "editions", ["title_id"], :name => "index_editions_on_title_id"

  create_table "event_locations", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "address"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "event_location_id"
    t.datetime "event_start"
    t.datetime "event_end"
    t.boolean  "published"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "picture"
    t.text     "introduction"
  end

  add_index "events", ["event_location_id"], :name => "index_events_on_event_location_id"

  create_table "images", :force => true do |t|
    t.string   "title"
    t.string   "the_image"
    t.integer  "imagey_id"
    t.string   "imagey_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
    t.string   "link"
  end

  create_table "invoice_line_items", :force => true do |t|
    t.integer  "quantity"
    t.integer  "edition_id"
    t.integer  "invoice_id"
    t.integer  "purchase_order_line_item_id"
    t.boolean  "is_transfer"
    t.float    "discount"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "price_in_cents"
    t.integer  "ext_in_cents"
  end

  add_index "invoice_line_items", ["edition_id"], :name => "index_invoice_line_items_on_edition_id"
  add_index "invoice_line_items", ["invoice_id"], :name => "index_invoice_line_items_on_invoice_id"
  add_index "invoice_line_items", ["purchase_order_line_item_id"], :name => "index_invoice_line_items_on_purchase_order_id"

  create_table "invoices", :force => true do |t|
    t.integer  "distributor_id"
    t.text     "notes"
    t.string   "number"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.boolean  "received"
    t.datetime "received_when"
    t.integer  "shipping_cost_in_cents"
    t.integer  "owner_id"
  end

  add_index "invoices", ["distributor_id"], :name => "index_invoices_on_distributor_id"

  create_table "owners", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "introduction"
    t.text     "body"
    t.integer  "parent_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "published"
    t.boolean  "is_hero"
    t.string   "layout"
    t.boolean  "is_image_grid"
  end

  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["published"], :name => "index_pages_on_published"
  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

  create_table "post_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "layout"
  end

  create_table "post_title_links", :force => true do |t|
    t.integer  "post_id"
    t.integer  "title_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "post_title_links", ["post_id"], :name => "index_post_title_links_on_post_id"
  add_index "post_title_links", ["title_id"], :name => "index_post_title_links_on_title_id"

  create_table "post_title_list_links", :force => true do |t|
    t.integer  "post_id"
    t.integer  "title_list_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "post_title_list_links", ["post_id"], :name => "index_post_title_list_links_on_post_id"
  add_index "post_title_list_links", ["title_list_id"], :name => "index_post_title_list_links_on_title_list_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "introduction"
    t.text     "body"
    t.integer  "post_category_id"
    t.boolean  "published"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "posts", ["published"], :name => "index_posts_on_published"
  add_index "posts", ["slug"], :name => "index_posts_on_slug", :unique => true

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "notes"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "purchase_order_line_items", :force => true do |t|
    t.integer  "quantity"
    t.integer  "edition_id"
    t.integer  "purchase_order_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "received"
    t.integer  "customer_id"
  end

  add_index "purchase_order_line_items", ["customer_id"], :name => "index_purchase_order_line_items_on_customer_id"
  add_index "purchase_order_line_items", ["edition_id"], :name => "index_purchase_order_line_items_on_edition_id"
  add_index "purchase_order_line_items", ["purchase_order_id"], :name => "index_purchase_order_line_items_on_purchase_order_id"

  create_table "purchase_orders", :force => true do |t|
    t.string   "number"
    t.text     "notes"
    t.integer  "distributor_id"
    t.boolean  "ordered"
    t.datetime "ordered_when"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "owner_id"
  end

  add_index "purchase_orders", ["distributor_id"], :name => "index_purchase_orders_on_distributor_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sale_order_line_items", :force => true do |t|
    t.integer  "sale_order_id"
    t.integer  "copy_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "sale_price_in_cents"
  end

  add_index "sale_order_line_items", ["copy_id"], :name => "index_sale_order_line_items_on_copy_id"
  add_index "sale_order_line_items", ["sale_order_id"], :name => "index_sale_order_line_items_on_sale_order_id"

  create_table "sale_orders", :force => true do |t|
    t.boolean  "from_pos"
    t.boolean  "from_web"
    t.string   "customer_po"
    t.integer  "customer_id"
    t.integer  "total_in_cents"
    t.boolean  "posted"
    t.integer  "discount_percent"
    t.integer  "tax_amount_in_cents"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
    t.text     "notes"
  end

  add_index "sale_orders", ["customer_id"], :name => "index_sale_orders_on_customer_id"
  add_index "sale_orders", ["user_id"], :name => "index_sale_orders_on_user_id"

  create_table "section_title_list_memberships", :force => true do |t|
    t.integer  "title_list_id_id"
    t.integer  "section_id_id"
    t.integer  "index"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "section_title_list_memberships", ["section_id_id"], :name => "index_section_title_list_memberships_on_section_id_id"
  add_index "section_title_list_memberships", ["title_list_id_id"], :name => "index_section_title_list_memberships_on_title_list_id_id"

  create_table "title_category_memberships", :force => true do |t|
    t.integer  "title_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "title_category_memberships", ["category_id"], :name => "index_title_category_memberships_on_category_id"
  add_index "title_category_memberships", ["title_id"], :name => "index_title_category_memberships_on_title_id"

  create_table "title_list_memberships", :force => true do |t|
    t.integer  "title_id"
    t.integer  "title_list_id"
    t.text     "notes"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "title_list_memberships", ["title_id"], :name => "index_title_list_memberships_on_title_id"
  add_index "title_list_memberships", ["title_list_id"], :name => "index_title_list_memberships_on_title_list_id"

  create_table "title_lists", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "public"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "titles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "description",  :limit => 16777215
    t.text     "introduction", :limit => 16777215
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
