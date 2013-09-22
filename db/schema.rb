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

ActiveRecord::Schema.define(version: 20130914194543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: true do |t|
    t.string   "name",            null: false
    t.integer  "manufacturer_id", null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.integer  "postcode"
    t.string   "name"
    t.integer  "country_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["country_id"], name: "index_cities_on_country_id", using: :btree

  create_table "classname_synonyms", force: true do |t|
    t.integer  "classname_id", null: false
    t.string   "sg",           null: false
    t.string   "pl",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classnames", force: true do |t|
    t.string   "sg",         null: false
    t.string   "pl",         null: false
    t.string   "abbr",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "comment",                 null: false
    t.integer  "user_id",                 null: false
    t.integer  "veganity_id", default: 4, null: false
    t.integer  "comment_id"
    t.integer  "product_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emailhashes", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "salt",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", force: true do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_synonyms", force: true do |t|
    t.integer  "ingredient_id", null: false
    t.string   "name",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", force: true do |t|
    t.string   "name",                               null: false
    t.text     "description"
    t.integer  "veganity_id",        default: 4,     null: false
    t.string   "image"
    t.string   "source"
    t.integer  "user_id",                            null: false
    t.boolean  "hide",               default: false, null: false
    t.boolean  "fixed",              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "inquiries", force: true do |t|
    t.boolean  "typ",         default: false, null: false
    t.text     "text",                        null: false
    t.integer  "user_id",                     null: false
    t.boolean  "highlight",   default: false, null: false
    t.integer  "veganity_id", default: 4,     null: false
    t.integer  "product_id",                  null: false
    t.boolean  "seen",        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "j_ingredient_classnames", force: true do |t|
    t.integer  "ingredient_id", null: false
    t.integer  "classname_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "j_ingredient_products", force: true do |t|
    t.integer  "ingredient_id", null: false
    t.integer  "product_id",    null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "j_ingredient_synonyms", force: true do |t|
    t.integer  "ingredient_id"
    t.string   "synonym"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "j_manufacturer_brands", force: true do |t|
    t.integer  "manufacturer_id", null: false
    t.integer  "brand_id",        null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "j_product_features", force: true do |t|
    t.integer  "product_id", null: false
    t.integer  "feature_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "j_product_ingredients", force: true do |t|
    t.integer  "product_id",    null: false
    t.integer  "ingredient_id", null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "j_product_labels", force: true do |t|
    t.integer  "product_id", null: false
    t.integer  "label_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: true do |t|
    t.string   "name",               null: false
    t.integer  "feature_id",         null: false
    t.string   "image"
    t.string   "source"
    t.integer  "user_id",            null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "manufacturers", force: true do |t|
    t.string   "name",               null: false
    t.string   "street"
    t.integer  "city_id"
    t.string   "http"
    t.string   "email"
    t.string   "tel"
    t.string   "fax"
    t.string   "image"
    t.integer  "user_id",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "nutvals", force: true do |t|
    t.string   "energy"
    t.string   "proteins"
    t.string   "carbohydrates"
    t.string   "sugar"
    t.string   "fat"
    t.string   "saturated"
    t.string   "monounsaturated"
    t.string   "polyunsaturated"
    t.string   "roughages"
    t.string   "natrium"
    t.string   "alcohol"
    t.integer  "user_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packagematerials", force: true do |t|
    t.string   "name",               null: false
    t.text     "description"
    t.string   "http"
    t.integer  "user_id",            null: false
    t.string   "image"
    t.string   "abbr"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "permissions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "points", force: true do |t|
    t.string   "name"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "gtin",                    limit: 8,             null: false
    t.string   "image"
    t.string   "name",                                          null: false
    t.text     "description"
    t.integer  "category_id"
    t.integer  "nutval_id"
    t.integer  "packagematerial_id"
    t.string   "packagesize"
    t.integer  "country_id"
    t.integer  "brand_id"
    t.integer  "veganity_ingredients_id",           default: 4, null: false
    t.integer  "veganity_inquiries_id",             default: 4, null: false
    t.integer  "veganity_comments_id",              default: 4, null: false
    t.integer  "veganity_source_id",                default: 4, null: false
    t.integer  "veganity_id",                       default: 4, null: false
    t.string   "source"
    t.integer  "integrity"
    t.integer  "user_id",                                       null: false
    t.integer  "up_user_id"
    t.text     "ingredients"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "traces"
    t.text     "contains"
  end

  create_table "providers", force: true do |t|
    t.string   "name",                       null: false
    t.text     "description",                null: false
    t.string   "fullname",                   null: false
    t.boolean  "aktiv",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", force: true do |t|
    t.string   "name",        null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "provider_id",                    null: false
    t.string   "uid",                            null: false
    t.string   "name",                           null: false
    t.string   "nickname",                       null: false
    t.string   "email",                          null: false
    t.datetime "lastlogin",                      null: false
    t.datetime "lastaction",                     null: false
    t.integer  "permission_id",  default: 0,     null: false
    t.integer  "points",         default: 0,     null: false
    t.boolean  "email_verified", default: false, null: false
    t.boolean  "anonymize_name", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "first_mail",     default: false, null: false
  end

  add_index "users", ["provider_id"], name: "index_users_on_provider_id", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "veganities", force: true do |t|
    t.string   "name",               null: false
    t.text     "description"
    t.string   "image"
    t.string   "color",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

end
