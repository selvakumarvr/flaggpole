class AddClientAndTypeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :client_id, :integer
    add_column :users, :type, :string
  end

  def self.down
    remove_column :users, :type
    remove_column :users, :client_id
  end
end
