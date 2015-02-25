class CreateMarketingTables < ActiveRecord::Migration
  def change
    
    create_table "mktg_affiliate_campaigns", force: true do |t|
      t.integer  "affiliate_id",                                           null: false
      t.string   "name",                                                   null: false
      t.string   "destination_url",                                        null: false
      t.decimal  "signup_commission", precision: 6, scale: 2,              null: false
      t.decimal  "sale_commission",   precision: 6, scale: 2,              null: false
      t.integer  "cookie_ttl",                                default: 30, null: false
      t.datetime "start_date",                                             null: false
      t.datetime "end_date",                                               null: false
      t.boolean  "record_history",                                         null: false
      t.integer  "raw_clicks",                                             null: false
      t.integer  "unique_clicks",                                          null: false
      t.integer  "signups",                                                null: false
      t.integer  "orders",                                                 null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "mktg_affiliate_campaigns", ["affiliate_id"], name: "index_affiliate_campaigns_on_affiliate_id", using: :btree
    
    create_table "mktg_email_blasts", force: true do |t|
      t.datetime "scheduled_time",                   null: false
      t.integer  "email_list_id",                    null: false
      t.integer  "sent",             default: 0,     null: false
      t.integer  "opens",            default: 0,     null: false
      t.integer  "bounces",          default: 0,     null: false
      t.integer  "clicks",           default: 0,     null: false
      t.integer  "sales",            default: 0,     null: false
      t.string   "key",                              null: false
      t.string   "title",                            null: false
      t.string   "from_name",                        null: false
      t.string   "from_email",                       null: false
      t.string   "subject",                          null: false
      t.text     "body"
      t.integer  "voucher_group_id"
      t.boolean  "approved",         default: false, null: false
      t.boolean  "test",             default: false, null: false
      t.boolean  "dispatched",       default: false, null: false
      t.datetime "dispatch_time"
      t.boolean  "html",                             null: false
      t.string   "html_body_url"
      t.string   "text_body_url"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "last_error"
    end

    add_index "mktg_email_blasts", ["email_list_id"], name: "index_email_blasts_on_email_list_id", using: :btree
    add_index "mktg_email_blasts", ["voucher_group_id"], name: "index_email_blasts_on_voucher_group_id", using: :btree

    create_table "mktg_email_lists", force: true do |t|
      t.string   "name",           null: false
      t.boolean  "auto_subscribe", null: false
      t.boolean  "user_managable", null: false
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "mktg_email_subscribers", force: true do |t|
      t.string   "email",                                 null: false
      t.string   "name"
      t.string   "ip_address", 
      t.integer  "affiliate_campaign_id"
      t.integer  "referred_by"
      t.integer  "bounces",               default: 0
      t.boolean  "reported_spam",         default: false
      t.boolean  "opted_out",             default: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "data1"
      t.string   "data2"
    end

    add_index "mktg_email_subscribers", ["affiliate_campaign_id"], name: "index_email_subscribers_on_affiliate_campaign_id", using: :btree

    create_table "mktg_email_subscriptions", force: true do |t|
      t.integer "email_subscriber_id", null: false
      t.integer "email_list_id",       null: false
    end

    add_index "mktg_email_subscriptions", ["email_list_id"], name: "index_email_subscriptions_on_email_list_id", using: :btree
    add_index "mktg_email_subscriptions", ["email_subscriber_id"], name: "index_email_subscriptions_on_email_subscriber_id", using: :btree
    
  end
end
