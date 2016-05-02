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

ActiveRecord::Schema.define(version: 20160502174947) do

  create_table "bp_custom_fields_field_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "label"
    t.integer  "group_template_id"
    t.integer  "field_type"
    t.text     "options"
    t.string   "min"
    t.string   "max"
    t.boolean  "required"
    t.text     "instructions"
    t.text     "default_value"
    t.text     "placeholder_text"
    t.string   "prepend"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "bp_custom_fields_field_templates", ["group_template_id"], name: "index_bp_custom_fields_field_templates_on_group_template_id"

  create_table "bp_custom_fields_fields", force: :cascade do |t|
    t.integer  "field_template_id"
    t.integer  "group_id"
    t.text     "value"
    t.string   "file"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "bp_custom_fields_fields", ["field_template_id"], name: "index_bp_custom_fields_fields_on_field_template_id"
  add_index "bp_custom_fields_fields", ["group_id"], name: "index_bp_custom_fields_fields_on_group_id"

  create_table "bp_custom_fields_group_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.boolean  "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "appears_on"
  end

  create_table "bp_custom_fields_groups", force: :cascade do |t|
    t.integer  "group_template_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "groupable_id"
    t.string   "groupable_type"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
