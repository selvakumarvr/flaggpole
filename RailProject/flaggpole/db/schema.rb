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

ActiveRecord::Schema.define(:version => 20130725002614) do

  create_table "alert_zips", :force => true do |t|
    t.integer  "alert_id"
    t.integer  "twitter_zip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alert_zips", ["alert_id"], :name => "index_alert_zips_on_alert_id"
  add_index "alert_zips", ["twitter_zip_id"], :name => "index_alert_zips_on_twitter_zip_id"

  create_table "alerts", :force => true do |t|
    t.string   "identifier",  :null => false
    t.text     "sender",      :null => false
    t.datetime "sent",        :null => false
    t.string   "status",      :null => false
    t.string   "msg_type",    :null => false
    t.string   "source"
    t.string   "scope",       :null => false
    t.text     "restriction"
    t.text     "addresses"
    t.string   "code"
    t.text     "note"
    t.text     "references"
    t.text     "incidents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_url"
  end

  add_index "alerts", ["identifier"], :name => "index_alerts_on_identifier"

  create_table "areas", :force => true do |t|
    t.integer  "info_id"
    t.text     "area_desc",  :null => false
    t.string   "altitude"
    t.string   "ceiling"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["info_id"], :name => "index_areas_on_info_id"

  create_table "circles", :force => true do |t|
    t.integer  "area_id"
    t.string   "circle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "circles", ["area_id"], :name => "index_circles_on_area_id"

  create_table "comment_msgs", :id => false, :force => true do |t|
    t.integer  "comment_id",   :default => 0, :null => false
    t.integer  "user_id",      :default => 0, :null => false
    t.integer  "message_type", :default => 0, :null => false
    t.datetime "lock_dt"
    t.integer  "revision",     :default => 0, :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"

  create_table "crawls", :force => true do |t|
    t.integer  "message_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rss_feed_id"
    t.string   "etag"
  end

  add_index "crawls", ["rss_feed_id"], :name => "index_crawls_on_rss_feed_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "token",                     :null => false
    t.integer  "badge",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["token"], :name => "index_devices_on_token", :unique => true
  add_index "devices", ["user_id"], :name => "index_devices_on_user_id"

  create_table "event_codes", :force => true do |t|
    t.integer  "info_id"
    t.string   "value_name", :null => false
    t.string   "value",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_codes", ["info_id"], :name => "index_event_codes_on_info_id"

  create_table "fema_ipaws_updates", :force => true do |t|
    t.datetime "update_time"
  end

  create_table "geocodes", :force => true do |t|
    t.integer  "area_id",    :null => false
    t.string   "value_name", :null => false
    t.string   "value",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geocodes", ["area_id"], :name => "index_geocodes_on_area_id"

  create_table "groupon_divisions", :force => true do |t|
    t.string  "division_id"
    t.string  "name"
    t.string  "timezone"
    t.integer "timezone_offset_gmt"
    t.integer "msa"
    t.string  "msa_name"
    t.decimal "latitude",            :precision => 12, :scale => 6
    t.decimal "longitude",           :precision => 12, :scale => 6
    t.text    "cj_link"
  end

  add_index "groupon_divisions", ["division_id"], :name => "index_groupon_divisions_on_division_id"

  create_table "groupon_zips", :force => true do |t|
    t.integer "groupon_division_id"
    t.integer "twitter_zip_id"
  end

  add_index "groupon_zips", ["groupon_division_id"], :name => "index_groupon_zips_on_groupon_division_id"
  add_index "groupon_zips", ["twitter_zip_id"], :name => "index_groupon_zips_on_twitter_zip_id"

  create_table "images", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.integer  "user_id"
  end

  add_index "images", ["post_id"], :name => "index_images_on_post_id"

  create_table "infos", :force => true do |t|
    t.integer  "alert_id"
    t.string   "category",      :null => false
    t.text     "language"
    t.text     "event",         :null => false
    t.string   "response_type"
    t.string   "urgency",       :null => false
    t.string   "severity",      :null => false
    t.string   "certainty",     :null => false
    t.text     "audience"
    t.datetime "effective"
    t.datetime "onset"
    t.datetime "expires"
    t.text     "sender_name"
    t.text     "headline"
    t.text     "description"
    t.text     "instruction"
    t.text     "web"
    t.text     "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "infos", ["alert_id"], :name => "index_infos_on_alert_id"
  add_index "infos", ["headline"], :name => "index_infos_on_headline", :length => {"headline"=>100}

  create_table "likes", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "likes", ["post_id"], :name => "index_likes_on_post_id"
  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "place_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["place_id", "user_id"], :name => "index_memberships_on_place_id", :unique => true
  add_index "memberships", ["user_id", "place_id"], :name => "index_memberships_on_user_id", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "source_id"
    t.string   "zip"
    t.string   "content"
    t.date     "created_at_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.boolean  "tweeted",         :default => false
    t.boolean  "enqueued",        :default => false
  end

  add_index "messages", ["created_at_date"], :name => "index_messages_on_created_at_date"
  add_index "messages", ["enqueued"], :name => "index_zip_messages_on_enqueued"
  add_index "messages", ["source_id"], :name => "index_zip_messages_on_source_id"
  add_index "messages", ["tweeted"], :name => "index_zip_messages_on_tweeted"
  add_index "messages", ["uid"], :name => "index_zip_messages_on_uid"
  add_index "messages", ["zip"], :name => "index_zip_messages_on_zip"

  create_table "notification_event_types", :force => true do |t|
    t.string "name"
  end

  create_table "notification_events", :force => true do |t|
    t.integer "user_id",                    :null => false
    t.integer "notification_event_type_id", :null => false
  end

  add_index "notification_events", ["user_id", "notification_event_type_id"], :name => "index_notification_events_on_user_id", :unique => true

  create_table "notification_method_types", :force => true do |t|
    t.string "name"
  end

  create_table "notification_methods", :force => true do |t|
    t.integer "user_id",                     :null => false
    t.integer "notification_method_type_id", :null => false
  end

  add_index "notification_methods", ["user_id", "notification_method_type_id"], :name => "index_notification_methods_on_user_id", :unique => true

  create_table "organization_links", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "organization_links", ["organization_id"], :name => "index_organization_links_on_organization_id"

  create_table "organization_messages", :force => true do |t|
    t.string   "message"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "organization_user_id"
  end

  add_index "organization_messages", ["organization_user_id"], :name => "index_organization_messages_on_organization_user_id"

  create_table "organization_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "organization_id"
    t.boolean  "admin"
  end

  add_index "organization_users", ["email"], :name => "index_organization_users_on_email", :unique => true
  add_index "organization_users", ["organization_id"], :name => "index_organization_users_on_organization_id"
  add_index "organization_users", ["reset_password_token"], :name => "index_organization_users_on_reset_password_token", :unique => true

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "line1"
    t.string   "line2"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "nces_id"
    t.string   "district_nces_id"
  end

  add_index "organizations", ["district_nces_id"], :name => "index_organizations_on_district_nces_id"
  add_index "organizations", ["nces_id"], :name => "index_organizations_on_nces_id"

  create_table "parameters", :force => true do |t|
    t.integer  "info_id"
    t.string   "value_name", :null => false
    t.string   "value",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parameters", ["info_id"], :name => "index_parameters_on_info_id"

  create_table "places", :force => true do |t|
    t.string   "name"
    t.decimal  "lat",         :precision => 9, :scale => 6
    t.decimal  "lng",         :precision => 9, :scale => 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "description"
    t.string   "place_type"
  end

  create_table "polygons", :force => true do |t|
    t.integer  "area_id"
    t.string   "polygon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "polygons", ["area_id"], :name => "index_polygons_on_area_id"

  create_table "post_msgs", :id => false, :force => true do |t|
    t.integer  "post_id",      :default => 0, :null => false
    t.integer  "user_id",      :default => 0, :null => false
    t.integer  "message_type", :default => 0, :null => false
    t.datetime "lock_dt"
    t.integer  "revision",     :default => 0, :null => false
  end

  create_table "postings", :force => true do |t|
    t.integer "place_id", :null => false
    t.integer "post_id",  :null => false
  end

  add_index "postings", ["place_id", "post_id"], :name => "index_postings_on_place_id", :unique => true
  add_index "postings", ["post_id", "place_id"], :name => "index_postings_on_post_id", :unique => true

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_type"
    t.integer  "comments_count", :default => 0
  end

  create_table "promotion_zips", :force => true do |t|
    t.integer  "promotion_id"
    t.integer  "twitter_zip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promotion_zips", ["promotion_id"], :name => "index_promotion_zips_on_promotion_id"
  add_index "promotion_zips", ["twitter_zip_id"], :name => "index_promotion_zips_on_twitter_zip_id"

  create_table "promotions", :force => true do |t|
    t.integer  "message_type"
    t.string   "message"
    t.datetime "send_at"
    t.boolean  "tweeted",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rapns_apps", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections", :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "type",                       :null => false
    t.string   "auth_key"
  end

  create_table "rapns_feedback", :force => true do |t|
    t.string   "device_token", :limit => 64, :null => false
    t.datetime "failed_at",                  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "app"
  end

  add_index "rapns_feedback", ["device_token"], :name => "index_rapns_feedback_on_device_token"

  create_table "rapns_notifications", :force => true do |t|
    t.integer  "badge"
    t.string   "device_token",      :limit => 64
    t.string   "sound",                                 :default => "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                                :default => 86400
    t.boolean  "delivered",                             :default => false,     :null => false
    t.datetime "delivered_at"
    t.boolean  "failed",                                :default => false,     :null => false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.boolean  "alert_is_json",                         :default => false
    t.string   "type",                                                         :null => false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                      :default => false,     :null => false
    t.text     "registration_ids",  :limit => 16777215
    t.integer  "app_id",                                                       :null => false
    t.integer  "retries",                               :default => 0
  end

  add_index "rapns_notifications", ["app_id", "delivered", "failed", "deliver_after"], :name => "index_rapns_notifications_multi"

  create_table "resources", :force => true do |t|
    t.integer  "info_id"
    t.text     "resource_desc", :null => false
    t.text     "mime_type",     :null => false
    t.integer  "size"
    t.text     "uri"
    t.text     "deref_uri"
    t.text     "digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["info_id"], :name => "index_resources_on_info_id"

  create_table "rss_feeds", :force => true do |t|
    t.integer "source_id"
    t.integer "twitter_zip_id"
    t.text    "rss_url"
    t.boolean "enabled"
    t.boolean "enqueued",       :default => false
  end

  add_index "rss_feeds", ["enabled"], :name => "index_rss_feeds_on_enabled"
  add_index "rss_feeds", ["enqueued"], :name => "index_rss_feeds_on_enqueued"
  add_index "rss_feeds", ["twitter_zip_id"], :name => "index_rss_feeds_on_twitter_zip_id"

  create_table "short_urls", :force => true do |t|
    t.text     "long_url"
    t.text     "destination_url"
    t.string   "user_hash"
    t.integer  "count",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "long_url_sha1"
  end

  add_index "short_urls", ["long_url_sha1"], :name => "index_short_urls_on_long_url_sha1", :unique => true
  add_index "short_urls", ["user_hash"], :name => "index_short_urls_on_user_hash"

  create_table "sources", :force => true do |t|
    t.string "name"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscribable_id"
    t.string   "subscribable_type"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "home",              :default => false
  end

  add_index "subscriptions", ["subscribable_id", "subscribable_type"], :name => "index_subscriptions_on_subscribable_id_and_subscribable_type"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "tandem_countries", :force => true do |t|
    t.string   "key"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tandem_countries", ["key"], :name => "index_tandem_countries_on_key", :unique => true

  create_table "tandem_districts", :force => true do |t|
    t.integer  "subdivision_id", :null => false
    t.string   "nces_id",        :null => false
    t.string   "name",           :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "tandem_districts", ["nces_id"], :name => "index_tandem_districts_on_nces_id", :unique => true
  add_index "tandem_districts", ["subdivision_id"], :name => "index_tandem_districts_on_subdivision_id"

  create_table "tandem_groups", :force => true do |t|
    t.integer  "school_id",   :null => false
    t.string   "key",         :null => false
    t.string   "name",        :null => false
    t.string   "events_url"
    t.string   "events_ical"
    t.string   "events_xcal"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tandem_groups", ["key"], :name => "index_tandem_groups_on_key"
  add_index "tandem_groups", ["school_id"], :name => "index_tandem_groups_on_school_id"

  create_table "tandem_schools", :force => true do |t|
    t.integer  "district_id",        :null => false
    t.string   "nces_id",            :null => false
    t.string   "name",               :null => false
    t.string   "yearly_events_url"
    t.string   "yearly_events_ical"
    t.string   "yearly_events_xcal"
    t.string   "events_url"
    t.string   "events_ical"
    t.string   "events_xcal"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "tandem_schools", ["district_id"], :name => "index_tandem_schools_on_district_id"
  add_index "tandem_schools", ["nces_id"], :name => "index_tandem_schools_on_nces_id", :unique => true

  create_table "tandem_subdivisions", :force => true do |t|
    t.integer  "country_id", :null => false
    t.string   "key",        :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tandem_subdivisions", ["country_id"], :name => "index_tandem_subdivisions_on_country_id"
  add_index "tandem_subdivisions", ["key"], :name => "index_tandem_subdivisions_on_key", :unique => true

  create_table "twitter_followers", :force => true do |t|
    t.integer "twitter_zip_id"
    t.string  "name"
    t.string  "screen_name"
    t.string  "location"
    t.string  "description"
    t.string  "url"
    t.integer "followers_count"
    t.integer "friends_count"
    t.boolean "following"
  end

  add_index "twitter_followers", ["screen_name"], :name => "index_twitter_followers_on_screen_name"
  add_index "twitter_followers", ["twitter_zip_id"], :name => "index_twitter_followers_on_twitter_zip_id"

  create_table "twitter_mentions", :force => true do |t|
    t.integer  "twitter_zip_id"
    t.integer  "mention_id",           :limit => 8
    t.datetime "mention_created_at"
    t.string   "text"
    t.string   "source"
    t.integer  "user_id"
    t.string   "user_screen_name"
    t.integer  "user_followers_count"
    t.integer  "user_friends_count"
    t.datetime "user_created_at"
    t.integer  "user_statuses_count"
    t.boolean  "following"
    t.boolean  "retweeted"
  end

  add_index "twitter_mentions", ["mention_id"], :name => "index_twitter_mentions_on_mention_id"
  add_index "twitter_mentions", ["twitter_zip_id"], :name => "index_twitter_mentions_on_twitter_zip_id"

  create_table "twitter_zips", :force => true do |t|
    t.string  "zip"
    t.string  "password"
    t.integer "population"
    t.string  "email"
    t.boolean "registered"
    t.integer "login_status",                                           :default => 1
    t.decimal "latitude",                :precision => 12, :scale => 6
    t.decimal "longitude",               :precision => 12, :scale => 6
    t.string  "state"
    t.string  "city"
    t.string  "county"
    t.string  "county_fips"
    t.string  "state_fips"
    t.string  "same"
    t.integer "msa"
    t.string  "msa_name"
    t.integer "twitter_followers_count",                                :default => 0
    t.integer "timezone"
    t.string  "oauth_token"
    t.string  "oauth_secret"
    t.integer "followers_count"
  end

  add_index "twitter_zips", ["login_status"], :name => "index_twitter_zips_on_login"
  add_index "twitter_zips", ["registered"], :name => "index_twitter_zips_on_registered"
  add_index "twitter_zips", ["same"], :name => "index_twitter_zips_on_same"
  add_index "twitter_zips", ["timezone"], :name => "index_twitter_zips_on_timezone"
  add_index "twitter_zips", ["zip"], :name => "index_twitter_zips_on_zip"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "authentication_token"
    t.string   "zip"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "zip_messages", :force => true do |t|
    t.integer  "source_id"
    t.string   "zip"
    t.string   "content"
    t.date     "created_at_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.boolean  "tweeted",         :default => false
    t.boolean  "enqueued",        :default => false
  end

  add_index "zip_messages", ["created_at_date"], :name => "index_zip_messages_on_created_at_date"
  add_index "zip_messages", ["enqueued"], :name => "index_zip_messages_on_enqueued"
  add_index "zip_messages", ["source_id"], :name => "index_zip_messages_on_source_id"
  add_index "zip_messages", ["tweeted"], :name => "index_zip_messages_on_tweeted"
  add_index "zip_messages", ["uid"], :name => "index_zip_messages_on_uid"
  add_index "zip_messages", ["zip"], :name => "index_zip_messages_on_zip"

end
