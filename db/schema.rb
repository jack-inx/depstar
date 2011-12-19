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

ActiveRecord::Schema.define(:version => 20111219153848) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "is_popular"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.string   "short_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_quotes", :force => true do |t|
    t.integer  "product_id"
    t.boolean  "question_1"
    t.boolean  "question_2"
    t.integer  "question_3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "question_options", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.float    "multiplier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_responses", :force => true do |t|
    t.integer  "product_id"
    t.string   "question_1"
    t.string   "question_2"
    t.string   "question_3"
    t.string   "question_4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_types", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.string   "name"
    t.integer  "question_type_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
