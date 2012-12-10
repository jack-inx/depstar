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


ActiveRecord::Schema.define(:version => 20121210103815) do


  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "carriers", :force => true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "carriers_manufacturers", :id => false, :force => true do |t|
    t.integer "carrier_id"
    t.integer "manufacturer_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "is_popular"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.boolean  "question_3_is_enabled"
    t.integer  "usell_category_code"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "categories_manufacturers", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "manufacturer_id"
  end

  create_table "devices", :force => true do |t|
    t.integer  "shipping_detail_id"
    t.integer  "product_id"
    t.integer  "question_response_id"
    t.float    "final_offer"
    t.integer  "status_code",          :default => 0, :null => false
    t.string   "notes"
    t.text     "serial"
    t.float    "offer"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.string   "short_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "is_popular"
    t.integer  "category_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.float    "price"
    t.boolean  "question_1_is_enabled"
    t.string   "question_1_name"
    t.float    "question_1_option_1_multiplier"
    t.float    "question_1_option_2_multiplier"
    t.boolean  "question_2_is_enabled"
    t.string   "question_2_name"
    t.float    "question_2_option_1_multiplier"
    t.float    "question_2_option_2_multiplier"
    t.boolean  "question_3_is_enabled"
    t.string   "question_3_name"
    t.float    "question_3_option_1_multiplier"
    t.float    "question_3_option_2_multiplier"
    t.float    "question_3_option_3_multiplier"
    t.float    "question_3_option_4_multiplier"
    t.boolean  "question_4_is_enabled"
    t.string   "question_4_name"
    t.string   "manufacturer"
    t.integer  "manufacturer_id"
    t.integer  "question_1_option_1_price"
    t.integer  "question_1_option_2_price"
    t.integer  "question_2_option_1_price"
    t.integer  "question_2_option_2_price"
    t.string   "carrier_id"
    t.integer  "series_list_id"
    t.integer  "used_price"
    t.integer  "broken_price"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.text     "website_url"
    t.text     "about_me"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "question_options", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.float    "multiplier"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "question_responses", :force => true do |t|
    t.integer  "product_id"
    t.string   "question_1"
    t.string   "question_2"
    t.string   "question_3"
    t.string   "question_4"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "series_lists", :force => true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "category_id"
    t.integer  "manufacturer_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shipping_details", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.integer  "payment_method_id"
    t.string   "paypal_email"
    t.integer  "product_id"
    t.boolean  "requires_box"
    t.integer  "question_response_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "phone"
    t.string   "uuid"
    t.string   "referer"
    t.integer  "final_offer"
    t.integer  "status_code",            :default => 0
    t.string   "notes"
    t.string   "serial"
    t.integer  "offer"
    t.string   "check_payment_name"
    t.string   "check_payment_address1"
    t.string   "check_payment_address2"
    t.string   "check_payment_city"
    t.string   "check_payment_state"
    t.string   "check_payment_zip"
    t.integer  "user_id"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
<<<<<<< HEAD
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
=======
    t.string    "username"
    t.string    "email"
    t.string    "crypted_password"
    t.string    "password_salt"
    t.string    "persistence_token"
    t.integer   "login_count",        :default => 0,    :null => false
    t.integer   "failed_login_count", :default => 0,    :null => false
    t.timestamp "last_request_at"
    t.timestamp "current_login_at"
    t.timestamp "last_login_at"
    t.string    "current_login_ip"
    t.string    "last_login_ip"
    t.timestamp "created_at",                           :null => false
    t.timestamp "updated_at",                           :null => false
    t.boolean   "status",             :default => true
>>>>>>> d1a70e43593938ec9dfdeed677efde77b487988c
  end

end
