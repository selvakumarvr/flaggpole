class AddHomeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :home, :boolean, :default => false
  end
end
