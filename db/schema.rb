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

ActiveRecord::Schema.define(:version => 20130428020205) do

  create_table "authors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "full_name"
  end

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
    t.integer  "distributor_id"
    t.integer  "owner_id"
    t.boolean  "is_used"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "invoice_id"
  end

  add_index "copies", ["distributor_id"], :name => "index_copies_on_distributor_id"
  add_index "copies", ["edition_id"], :name => "index_copies_on_edition_id"
  add_index "copies", ["invoice_id"], :name => "index_copies_on_invoice_id"
  add_index "copies", ["owner_id"], :name => "index_copies_on_owner_id"

  create_table "editions", :force => true do |t|
    t.string   "isbn13"
    t.string   "isbn10"
    t.integer  "year_of_publication"
    t.string   "format"
    t.boolean  "in_print"
    t.text     "notes"
    t.integer  "title_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "cover"
  end

  add_index "editions", ["title_id"], :name => "index_editions_on_title_id"

  create_table "invoice_line_items", :force => true do |t|
    t.integer  "quantity"
    t.integer  "edition_id"
    t.integer  "invoice_id"
    t.integer  "purchase_order_id"
    t.boolean  "is_transfer"
    t.float    "discount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "invoice_line_items", ["edition_id"], :name => "index_invoice_line_items_on_edition_id"
  add_index "invoice_line_items", ["invoice_id"], :name => "index_invoice_line_items_on_invoice_id"
  add_index "invoice_line_items", ["purchase_order_id"], :name => "index_invoice_line_items_on_purchase_order_id"

  create_table "invoices", :force => true do |t|
    t.integer  "distributor_id"
    t.text     "notes"
    t.string   "number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "invoices", ["distributor_id"], :name => "index_invoices_on_distributor_id"

  create_table "purchase_order_line_items", :force => true do |t|
    t.integer  "quantity"
    t.integer  "edition_id"
    t.integer  "purchase_order_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "purchase_order_line_items", ["edition_id"], :name => "index_purchase_order_line_items_on_edition_id"
  add_index "purchase_order_line_items", ["purchase_order_id"], :name => "index_purchase_order_line_items_on_purchase_order_id"

  create_table "purchase_orders", :force => true do |t|
    t.string   "number"
    t.text     "notes"
    t.integer  "customer_id"
    t.integer  "distributor_id"
    t.boolean  "ordered"
    t.datetime "ordered_when"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "purchase_orders", ["customer_id"], :name => "index_purchase_orders_on_customer_id"
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

  create_table "titles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
