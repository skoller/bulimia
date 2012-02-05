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

ActiveRecord::Schema.define(:version => 20120204054531) do

  create_table "convo_handlers", :force => true do |t|
    t.string   "state"
    t.integer  "patient_id"
    t.integer  "log_entry_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "convo_handlers", ["log_entry_id"], :name => "index_convo_handlers_on_log_entry_id"
  add_index "convo_handlers", ["patient_id"], :name => "index_convo_handlers_on_patient_id"

  create_table "log_entries", :force => true do |t|
    t.integer  "day"
    t.text     "food"
    t.boolean  "binge"
    t.boolean  "vomit"
    t.boolean  "laxative"
    t.text     "personal_notes"
    t.string   "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
    t.datetime "date"
    t.integer  "convo_handler_id"
  end

  add_index "log_entries", ["convo_handler_id"], :name => "index_log_entries_on_convo_handler_id"
  add_index "log_entries", ["patient_id"], :name => "index_log_entries_on_patient_id"

  create_table "patients", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "dob"
    t.string   "sex"
    t.float    "diagnosis"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
  end

end
