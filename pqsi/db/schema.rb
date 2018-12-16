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

ActiveRecord::Schema.define(:version => 20170826121202) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "csv_exports", :force => true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "ncm_id"
    t.string   "filter_hash"
  end

  create_table "customer_vendors", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_vendors", ["customer_id", "vendor_id"], :name => "index_customer_vendors_on_customer_id_and_vendor_id"

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "emails", :force => true do |t|
    t.string   "to"
    t.string   "from"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  add_index "locations", ["customer_id"], :name => "index_locations_on_customer_id"

  create_table "ncm_data_files", :force => true do |t|
    t.string   "ncm_data_file_document"
    t.integer  "ncm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.string   "status"
    t.text     "existing_rows"
    t.integer  "existing_row_count"
    t.text     "error_rows"
    t.integer  "error_row_count"
    t.text     "saved_rows"
    t.integer  "saved_row_count"
  end

  create_table "ncms", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "quantity"
    t.integer  "authorizer_id"
    t.string   "vendor_id"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "internal_id"
    t.integer  "location_id"
    t.string   "temporary_location"
    t.text     "work_instructions"
    t.string   "work_instructions_document"
    t.string   "contact_email"
    t.string   "contact_cell"
    t.date     "report_start_date"
    t.date     "report_end_date"
    t.text     "ncm_number"
    t.string   "sqe_pqe"
    t.string   "mi_name"
    t.string   "part_name"
    t.string   "cost_center_type"
    t.string   "cost_center_name"
    t.string   "supplier_name"
    t.string   "supplier_code"
    t.string   "supplier_address"
    t.string   "supplier_city"
    t.string   "supplier_state"
    t.string   "supplier_zip"
    t.string   "supplier_contact"
    t.string   "supplier_phone"
    t.integer  "job_id"
    t.string   "clipboard"
    t.string   "report_emails"
    t.date     "last_report_sent_at"
    t.boolean  "archive",                    :default => false
  end

  add_index "ncms", ["customer_id"], :name => "index_ncms_on_customer_id"

  create_table "parts", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pdf_exports", :force => true do |t|
    t.string   "file"
    t.integer  "user_id"
    t.integer  "ncm_id"
    t.string   "filter_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "permissionable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permissionable_type"
  end

  add_index "permissions", ["user_id", "permissionable_type", "permissionable_id"], :name => "index_permissions_on_user_id_and_p_type_and_p_id"

  create_table "reports", :force => true do |t|
    t.date     "start_on"
    t.date     "end_on"
    t.integer  "ncm_id"
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "client_id"
  end

  create_table "scans", :force => true do |t|
    t.integer  "part_id"
    t.integer  "quantity"
    t.text     "description"
    t.string   "serial"
    t.integer  "rejects_old"
    t.date     "scanned_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ncm_id"
    t.string   "lot_number"
    t.date     "manufacturing_date"
    t.string   "part_number"
    t.string   "shift"
    t.text     "comments"
    t.string   "ipn"
    t.string   "row_id"
    t.string   "reject_reason_1_label"
    t.string   "reject_reason_2_label"
    t.string   "reject_reason_3_label"
    t.string   "reject_reason_4_label"
    t.string   "reject_reason_5_label"
    t.integer  "reject_reason_1_quantity"
    t.integer  "reject_reason_2_quantity"
    t.integer  "reject_reason_3_quantity"
    t.integer  "reject_reason_4_quantity"
    t.integer  "reject_reason_5_quantity"
  end

  add_index "scans", ["ncm_id", "row_id"], :name => "index_scans_on_ncm_id_and_row_id"
  add_index "scans", ["ncm_id"], :name => "index_scans_on_ncm_id"

  create_table "time_entries", :force => true do |t|
    t.string   "shift"
    t.integer  "ncm_id"
    t.float    "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.integer  "user_id"
    t.string   "entry_type"
  end

  add_index "time_entries", ["user_id"], :name => "index_time_entries_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",    :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.integer  "client_id"
    t.string   "level"
    t.integer  "customer_id"
    t.integer  "location_id"
    t.string   "token_authenticatable"
  end

  add_index "users", ["customer_id"], :name => "index_users_on_customer_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["location_id"], :name => "index_users_on_location_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["token_authenticatable"], :name => "index_users_on_token_authenticatable", :unique => true

end
