class RenameTypeToLevelInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :type, :level
  end

  def self.down
    rename_column :users, :level, :type
  end
end
