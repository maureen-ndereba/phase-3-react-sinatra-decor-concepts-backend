# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_07_29_150611) do

  create_table "designers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "designer_id"
    t.bigint "project_proposal_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "message"
    t.index ["designer_id"], name: "index_notes_on_designer_id"
    t.index ["project_proposal_id"], name: "index_notes_on_project_proposal_id"
  end

  create_table "project_proposals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "designer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_estimate"
    t.text "material_list"
    t.index ["designer_id"], name: "index_project_proposals_on_designer_id"
  end

  add_foreign_key "notes", "designers"
  add_foreign_key "notes", "project_proposals"
  add_foreign_key "project_proposals", "designers"
end
