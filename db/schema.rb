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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160607021506) do

  create_table "logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "case_id"
  end

  create_table "qa_suites", force: :cascade do |t|
    t.string   "suite_name"
    t.string   "branch"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "build_type"
    t.string   "command_line"
    t.string   "executable"
    t.string   "host"
    t.string   "display"
    t.string   "pid"
    t.text     "failed_info"
    t.text     "diffs_info"
    t.text     "asserts_info"
    t.text     "warnings_info"
    t.text     "status"
    t.integer  "pass_number"
    t.integer  "failed_numnber"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "date"
    t.string   "log_file"
    t.string   "version",        default: "master"
    t.string   "platform",       default: "linux_x86_64_rhel6"
  end

  create_table "test_cases", force: :cascade do |t|
    t.string   "case_name"
    t.string   "suite_name"
    t.string   "group"
    t.string   "branch"
    t.string   "host"
    t.string   "status"
    t.datetime "s_time"
    t.datetime "e_time"
    t.string   "build_type"
    t.string   "work_path"
    t.string   "diff_file_path"
    t.string   "qa_log_path"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "suite_id"
  end

  add_index "test_cases", ["case_name", "created_at"], name: "index_test_cases_on_case_name_and_created_at"

  create_table "virtual_users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "user_session"
    t.string   "version",      default: "master"
    t.string   "platform",     default: "linux_x86_64_rhel6"
    t.string   "timestamp",    default: "today"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "virtual_users", ["user_name", "user_session"], name: "index_virtual_users_on_user_name_and_user_session"

end
