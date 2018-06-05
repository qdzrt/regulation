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

ActiveRecord::Schema.define(version: 20180601080549) do

  create_table "credit_evals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "score_gteq"
    t.integer "score_lt"
    t.string "grade"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_evals_on_user_id"
  end

  create_table "loan_fees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "credit_eval_id"
    t.bigint "product_id"
    t.bigint "user_id"
    t.integer "times"
    t.decimal "management_fee", precision: 3, scale: 2
    t.decimal "dayly_fee", precision: 3, scale: 2
    t.decimal "weekly_fee", precision: 3, scale: 2
    t.decimal "monthly_fee", precision: 3, scale: 2
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_eval_id"], name: "index_loan_fees_on_credit_eval_id"
    t.index ["product_id"], name: "index_loan_fees_on_product_id"
    t.index ["user_id"], name: "index_loan_fees_on_user_id"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "period_num"
    t.integer "period_unit", default: 1
    t.bigint "user_id"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "credit_evals", "users"
  add_foreign_key "loan_fees", "credit_evals"
  add_foreign_key "loan_fees", "products"
  add_foreign_key "loan_fees", "users"
  add_foreign_key "products", "users"
end