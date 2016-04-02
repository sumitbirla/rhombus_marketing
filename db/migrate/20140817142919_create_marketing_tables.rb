class CreateMarketingTables < ActiveRecord::Migration
  def change
    
    create_table "mktg_affiliate_campaigns", force: :cascade do |t|
      t.integer  "affiliate_id",      limit: 4,                                        null: false
      t.string   "name",              limit: 255,                                      null: false
      t.string   "destination_url",   limit: 255,                                      null: false
      t.decimal  "signup_commission",             precision: 6, scale: 2,              null: false
      t.decimal  "sale_commission",               precision: 6, scale: 2,              null: false
      t.integer  "cookie_ttl",        limit: 4,                           default: 30, null: false
      t.datetime "start_date",                                                         null: false
      t.datetime "end_date",                                                           null: false
      t.boolean  "record_history",                                                     null: false
      t.integer  "raw_clicks",        limit: 4,                                        null: false
      t.integer  "unique_clicks",     limit: 4,                                        null: false
      t.integer  "signups",           limit: 4,                                        null: false
      t.integer  "orders",            limit: 4,                                        null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "opens",             limit: 4,                           default: 0,  null: false
    end

    add_index "mktg_affiliate_campaigns", ["affiliate_id"], name: "index_affiliate_campaigns_on_affiliate_id", using: :btree

    create_table "mktg_email_blasts", force: :cascade do |t|
      t.datetime "scheduled_time",                                 null: false
      t.integer  "email_list_id",    limit: 4,                     null: false
      t.integer  "sent",             limit: 4,     default: 0,     null: false
      t.integer  "opens",            limit: 4,     default: 0,     null: false
      t.integer  "bounces",          limit: 4,     default: 0,     null: false
      t.integer  "clicks",           limit: 4,     default: 0,     null: false
      t.integer  "sales",            limit: 4,     default: 0,     null: false
      t.string   "uuid",             limit: 255,                   null: false
      t.string   "title",            limit: 255,                   null: false
      t.string   "from_name",        limit: 255,                   null: false
      t.string   "from_email",       limit: 255,                   null: false
      t.string   "subject",          limit: 255,                   null: false
      t.text     "body",             limit: 65535
      t.integer  "voucher_group_id", limit: 4
      t.boolean  "approved",                       default: false, null: false
      t.boolean  "test",                           default: false, null: false
      t.boolean  "dispatched",                     default: false, null: false
      t.datetime "dispatch_time"
      t.boolean  "html",                                           null: false
      t.string   "html_body_url",    limit: 255
      t.string   "text_body_url",    limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "last_error",       limit: 255
    end

    add_index "mktg_email_blasts", ["email_list_id"], name: "index_email_blasts_on_email_list_id", using: :btree
    add_index "mktg_email_blasts", ["voucher_group_id"], name: "index_email_blasts_on_voucher_group_id", using: :btree

    create_table "mktg_email_lists", force: :cascade do |t|
      t.string   "name",           limit: 255,   null: false
      t.boolean  "auto_subscribe",               null: false
      t.boolean  "user_managable",               null: false
      t.text     "description",    limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "mktg_email_subscribers", force: :cascade do |t|
      t.string   "email",                 limit: 255,                   null: false
      t.string   "name",                  limit: 255
      t.string   "ip_address",            limit: 255,                   null: false
      t.integer  "affiliate_campaign_id", limit: 4
      t.integer  "referred_by",           limit: 4
      t.integer  "bounces",               limit: 4,     default: 0
      t.boolean  "reported_spam",                       default: false
      t.boolean  "opted_out",                           default: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "data1",                 limit: 255
      t.string   "data2",                 limit: 255
      t.string   "uuid",                  limit: 255,                   null: false
      t.datetime "last_seen"
      t.text     "last_error",            limit: 65535
    end

    add_index "mktg_email_subscribers", ["affiliate_campaign_id"], name: "index_email_subscribers_on_affiliate_campaign_id", using: :btree

    create_table "mktg_email_subscriptions", force: :cascade do |t|
      t.integer "email_subscriber_id", limit: 4, null: false
      t.integer "email_list_id",       limit: 4, null: false
    end

    add_index "mktg_email_subscriptions", ["email_list_id"], name: "index_email_subscriptions_on_email_list_id", using: :btree
    add_index "mktg_email_subscriptions", ["email_subscriber_id"], name: "index_email_subscriptions_on_email_subscriber_id", using: :btree
    
  end
end
