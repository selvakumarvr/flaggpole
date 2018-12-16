class AddShortUrlToAlerts < ActiveRecord::Migration
  def change
  	add_column :alerts, :short_url, :string
  end
end
