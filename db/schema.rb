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

ActiveRecord::Schema.define(version: 20160518100126) do

  PRAGMA FOREIGN_KEYS = ON;
  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "userschool"
    t.string   "usermajor"
    t.string   "userpw"
    t.string   "usermail"
    t.string   "userphone"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "sellbooks", force: :cascade do |t|
    t.string   "booktitle"
    t.string   "book_image"
    t.string   "bookauthor"
    t.string   "bookpublisher"
    t.integer  "bookprice"
    t.integer  "nowbookprice"
    t.integer  "bookstate"
    t.integer  "booksellterm"
    t.integer  "user_id",       :foreign_key=>{:references=>"users", :name=>"fk_sellbooks_user_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__sellbooks_user_id"}
    t.datetime "created_at",    :null=>false
    t.datetime "updated_at",    :null=>false
  end

  create_table "auctions", force: :cascade do |t|
    t.integer  "user_id",      :foreign_key=>{:references=>"users", :name=>"fk_auctions_user_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__auctions_user_id"}
    t.integer  "sellbook_id",  :foreign_key=>{:references=>"sellbooks", :name=>"fk_auctions_sellbook_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__auctions_sellbook_id"}
    t.integer  "auctionprice"
    t.datetime "created_at",   :null=>false
    t.datetime "updated_at",   :null=>false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tagname"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "sellbooks_tags", force: :cascade do |t|
    t.integer  "tag_id",      :foreign_key=>{:references=>"tags", :name=>"fk_sellbooks_tags_tag_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__sellbooks_tags_tag_id"}
    t.integer  "sellbook_id", :foreign_key=>{:references=>"sellbooks", :name=>"fk_sellbooks_tags_sellbook_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__sellbooks_tags_sellbook_id"}
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
  end

end
