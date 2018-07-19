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

ActiveRecord::Schema.define(version: 20180714222447) do

  create_table "accounts", force: :cascade do |t|
    t.float    "deuda",      default: 0.0
    t.float    "saldo",      default: 0.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.text     "respuesta"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "embarkments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "estado",     default: "p"
    t.float    "deuda",      default: 0.0
    t.index ["trip_id"], name: "index_embarkments_on_trip_id"
    t.index ["user_id"], name: "index_embarkments_on_user_id"
  end

  create_table "owners", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_owners_on_user_id"
    t.index ["vehicle_id"], name: "index_owners_on_vehicle_id"
  end

  create_table "periodics", force: :cascade do |t|
    t.date     "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "trip_id"
    t.index ["trip_id"], name: "index_periodics_on_trip_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text     "pregunta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "trip_id"
    t.integer  "user_id"
    t.index ["trip_id"], name: "index_questions_on_trip_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "calificacion"
    t.text     "descripcion"
    t.date     "fecha"
    t.time     "hora"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "calificado_id"
    t.integer  "creador_id"
    t.string   "tipo_calificacion"
    t.boolean  "realizada"
    t.index ["calificado_id"], name: "index_scores_on_calificado_id"
    t.index ["creador_id"], name: "index_scores_on_creador_id"
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.text     "descripcion"
    t.integer  "user_id"
    t.date     "fecha_inicio"
    t.time     "hora_inicio"
    t.float    "costo"
    t.string   "destino"
    t.integer  "vehicle_id"
    t.boolean  "activo",                     default: true
    t.integer  "cantidad_asientos_ocupados", default: 1
    t.string   "origen"
    t.boolean  "pagado",                     default: false
    t.integer  "duracion"
    t.index ["user_id"], name: "index_trips_on_user_id"
    t.index ["vehicle_id"], name: "index_trips_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "nombre"
    t.string   "apellido"
    t.date     "fecha_nacimiento"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "telefono"
    t.string   "tarjeta"
    t.boolean  "eliminado",              default: false
    t.date     "fecha_vencimiento"
    t.integer  "calificacionPiloto",     default: 0
    t.integer  "calificacionCopiloto",   default: 0
    t.integer  "codigoSeguridad"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string   "patente"
    t.integer  "modelo"
    t.string   "marca"
    t.integer  "cantidad_asientos"
    t.string   "color"
    t.string   "tipo"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "sub_marca"
  end

end
