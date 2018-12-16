class CreateFemaIpawsUpdates < ActiveRecord::Migration
  def self.up
    create_table :fema_ipaws_updates do |t|
      t.datetime :update_time
    end
    FemaIpawsUpdate.create(update_time: Time.now)
  end

  def self.down
    drop_table :fema_ipaws_updates
  end
end
