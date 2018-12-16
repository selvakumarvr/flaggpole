class AddIndexOnIdentifier < ActiveRecord::Migration
  def self.up
    add_index :alerts, :identifier
  end

  def self.down
    remove_index :alerts, :identifier
  end
end
